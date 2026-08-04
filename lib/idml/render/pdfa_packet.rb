# frozen_string_literal: true

module Idml
  module Render
    # Builds the PDF/A-2a XMP packet and attaches it to the PDF
    # Catalog as the `/Metadata` stream. PDF/A requires:
    #
    #   1. An XMP metadata stream on `/Catalog` (not just `/Info`).
    #   2. The packet must declare `pdfaid:part` and `pdfaid:conformance`.
    #   3. `dc:format` must be `application/pdf`.
    #
    # ICC profile (output intent) embedding is handled separately by
    # `OutputIntents#embed_icc` — see TODO 77 for the deferred plan
    # to bundle sRGB and register the intent.
    #
    # The packet is built from the same fields already threaded
    # through `PdfrbWriter#set_info`, so PDF/A output reuses the
    # XMP-extracted values from the IDML packet (TODO 75).
    module PdfaPacket
      PDF_A_PART = 2
      PDF_A_CONFORMANCE = "A"

      # Returns the XMP packet bytes suitable for a `/Metadata` stream.
      # @param metadata [Hash{Symbol => String}] the Info-dict fields
      #   already assembled by the pipeline.
      def self.build(metadata)
        body = rdf_description(metadata)
        "#{XMP_BEGIN}#{body}#{XMP_END}"
      end

      # Attaches the built packet to the document's Catalog as the
      # `/Metadata` stream and sets `/Lang`. Idempotent — replaces
      # any existing `/Metadata`.
      def self.attach(document, metadata)
        xmp = build(metadata)
        stream = document.add(
          { Type: :Metadata, Subtype: :XML, Length: xmp.bytesize },
          type: Pdfrb::Model::Cos::Stream,
        )
        stream.stream = xmp
        document.catalog.value[:Metadata] =
          Pdfrb::Model::Reference.new(stream.oid, stream.gen)
        document.catalog.value[:Lang] ||= "en-US"
      end

      XMP_BEGIN = "<?xpacket begin=\"﻿\" id=\"W5M0MpCehiHzreSzNTczkc9d\"?>\n"
      XMP_END = "<?xpacket end=\"w\"?>\n"
      private_constant :XMP_BEGIN, :XMP_END

      def self.rdf_description(metadata)
        lines = [
          '<x:xmpmeta xmlns:x="adobe:ns:meta/">',
          '<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">',
          '<rdf:Description rdf:about=""',
          '    xmlns:dc="http://purl.org/dc/elements/1.1/"',
          '    xmlns:pdf="http://ns.adobe.com/pdf/1.3/"',
          '    xmlns:xmp="http://ns.adobe.com/xap/1.0/"',
          '    xmlns:pdfaid="http://www.aiim.org/pdfa/ns/id/">',
        ]
        lines += pdfaid_lines
        lines += dc_lines(metadata)
        lines += pdf_lines(metadata)
        lines += xmp_lines(metadata)
        lines << "</rdf:Description>"
        lines << "</rdf:RDF>"
        lines << "</x:xmpmeta>"
        "#{lines.join("\n")}\n"
      end
      private_class_method :rdf_description

      def self.pdfaid_lines
        [
          "  <pdfaid:part>#{PDF_A_PART}</pdfaid:part>",
          "  <pdfaid:conformance>#{PDF_A_CONFORMANCE}</pdfaid:conformance>",
        ]
      end
      private_class_method :pdfaid_lines

      def self.dc_lines(metadata)
        lines = []
        if metadata[:Title]
          lines << '  <dc:title><rdf:Alt><rdf:li xml:lang="x-default">' \
                   "#{escape(metadata[:Title])}</rdf:li></rdf:Alt></dc:title>"
        end
        if metadata[:Author]
          lines << "  <dc:creator><rdf:Seq>" \
                   "<rdf:li>#{escape(metadata[:Author])}</rdf:li>" \
                   "</rdf:Seq></dc:creator>"
        end
        if metadata[:Subject]
          lines << '  <dc:description><rdf:Alt><rdf:li xml:lang="x-default">' \
                   "#{escape(metadata[:Subject])}</rdf:li></rdf:Alt></dc:description>"
        end
        lines
      end
      private_class_method :dc_lines

      def self.pdf_lines(metadata)
        return [] unless metadata[:Keywords]

        ["  <pdf:Keywords>#{escape(metadata[:Keywords])}</pdf:Keywords>"]
      end
      private_class_method :pdf_lines

      def self.xmp_lines(metadata)
        lines = []
        lines << "  <dc:format>application/pdf</dc:format>"
        if metadata[:Creator]
          lines << "  <xmp:CreatorTool>#{escape(metadata[:Creator])}</xmp:CreatorTool>"
        end
        lines << xmp_date_line("CreateDate", metadata[:CreationDate])
        lines << xmp_date_line("ModifyDate", metadata[:ModDate])
        lines << xmp_date_line("MetadataDate", metadata[:CreationDate])
        lines.compact
      end
      private_class_method :xmp_lines

      def self.xmp_date_line(name, value)
        return nil unless value

        "  <xmp:#{name}>#{escape(value)}</xmp:#{name}>"
      end
      private_class_method :xmp_date_line

      def self.escape(text)
        text.to_s
          .gsub("&", "&amp;")
          .gsub("<", "&lt;")
          .gsub(">", "&gt;")
          .gsub('"', "&quot;")
      end
      private_class_method :escape
    end
  end
end
