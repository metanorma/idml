# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for the package's `preferences.xml` part.
    # Every child element from `reference-docs/schemas/package/Resources/Preferences.rnc` is typed — generated
    # via `scripts/rnc_to_lutaml.rb` + `scripts/assemble_element.rb`.
    class Preferences < Lutaml::Model::Serializable
      include Idml::Part

      part_file "Resources/Preferences.xml"

      attribute :dom_version, :string
      attribute :button_preference, Idml::Elements::ButtonPreference,
                collection: true
      attribute :print_preference, Idml::Elements::PrintPreference,
                collection: true
      attribute :print_booklet_option, Idml::Elements::PrintBookletOption,
                collection: true
      attribute :print_booklet_print_preference,
                Idml::Elements::PrintBookletPrintPreference, collection: true
      attribute :page_item_default, Idml::Elements::PageItemDefault,
                collection: true
      attribute :transparency_setting, Idml::Elements::TransparencySetting,
                collection: true
      attribute :blending_setting, Idml::Elements::BlendingSetting,
                collection: true
      attribute :drop_shadow_setting, Idml::Elements::DropShadowSetting,
                collection: true
      attribute :feather_setting, Idml::Elements::FeatherSetting,
                collection: true
      attribute :inner_shadow_setting, Idml::Elements::InnerShadowSetting,
                collection: true
      attribute :outer_glow_setting, Idml::Elements::OuterGlowSetting,
                collection: true
      attribute :inner_glow_setting, Idml::Elements::InnerGlowSetting,
                collection: true
      attribute :bevel_and_emboss_setting,
                Idml::Elements::BevelAndEmbossSetting, collection: true
      attribute :satin_setting, Idml::Elements::SatinSetting, collection: true
      attribute :directional_feather_setting,
                Idml::Elements::DirectionalFeatherSetting, collection: true
      attribute :gradient_feather_setting,
                Idml::Elements::GradientFeatherSetting, collection: true
      attribute :opacity_gradient_stop, Idml::Elements::OpacityGradientStop,
                collection: true
      attribute :stroke_transparency_setting,
                Idml::Elements::StrokeTransparencySetting, collection: true
      attribute :fill_transparency_setting,
                Idml::Elements::FillTransparencySetting, collection: true
      attribute :content_transparency_setting,
                Idml::Elements::ContentTransparencySetting, collection: true
      attribute :frame_fitting_option, Idml::Elements::FrameFittingOption,
                collection: true
      attribute :story_preference, Idml::Elements::StoryPreference,
                collection: true
      attribute :text_frame_preference, Idml::Elements::TextFramePreference,
                collection: true
      attribute :text_preference, Idml::Elements::TextPreference,
                collection: true
      attribute :text_default, Idml::Elements::TextDefault, collection: true
      attribute :dictionary_preference, Idml::Elements::DictionaryPreference,
                collection: true
      attribute :anchored_object_default,
                Idml::Elements::AnchoredObjectDefault, collection: true
      attribute :anchored_object_setting,
                Idml::Elements::AnchoredObjectSetting, collection: true
      attribute :baseline_frame_grid_option,
                Idml::Elements::BaselineFrameGridOption, collection: true
      attribute :footnote_option, Idml::Elements::FootnoteOption,
                collection: true
      attribute :text_wrap_preference, Idml::Elements::TextWrapPreference,
                collection: true
      attribute :contour_option, Idml::Elements::ContourOption, collection: true
      attribute :mojikumi_ui_preference, Idml::Elements::MojikumiUiPreference,
                collection: true
      attribute :xml_import_preference, Idml::Elements::XMLImportPreference,
                collection: true
      attribute :xml_export_preference, Idml::Elements::XMLExportPreference,
                collection: true
      attribute :xml_preference, Idml::Elements::XMLPreference, collection: true
      attribute :export_for_web_preference,
                Idml::Elements::ExportForWebPreference, collection: true
      attribute :index_options, Idml::Elements::IndexOptions, collection: true
      attribute :index_header_setting, Idml::Elements::IndexHeaderSetting,
                collection: true
      attribute :tin_document_data_object,
                Idml::Elements::TinDocumentDataObject, collection: true
      attribute :chapter_number_preference,
                Idml::Elements::ChapterNumberPreference, collection: true
      attribute :document_preference, Idml::Elements::DocumentPreference,
                collection: true
      attribute :grid_preference, Idml::Elements::GridPreference,
                collection: true
      attribute :guide_preference, Idml::Elements::GuidePreference,
                collection: true
      attribute :margin_preference, Idml::Elements::MarginPreference,
                collection: true
      attribute :pasteboard_preference, Idml::Elements::PasteboardPreference,
                collection: true
      attribute :view_preference, Idml::Elements::ViewPreference,
                collection: true
      attribute :transparency_preference,
                Idml::Elements::TransparencyPreference, collection: true
      attribute :transparency_default_container_object,
                Idml::Elements::TransparencyDefaultContainerObject, collection: true
      attribute :layout_grid_data_information,
                Idml::Elements::LayoutGridDataInformation, collection: true
      attribute :story_grid_data_information,
                Idml::Elements::StoryGridDataInformation, collection: true
      attribute :cjk_grid_preference, Idml::Elements::CjkGridPreference,
                collection: true
      attribute :data_merge, Idml::Elements::DataMerge, collection: true
      attribute :data_merge_field, Idml::Elements::DataMergeField,
                collection: true
      attribute :data_merge_option, Idml::Elements::DataMergeOption,
                collection: true
      attribute :layout_adjustment_preference,
                Idml::Elements::LayoutAdjustmentPreference, collection: true
      attribute :e_pub_export_preference, Idml::Elements::EPubExportPreference,
                collection: true
      attribute :html_export_preference, Idml::Elements::HTMLExportPreference,
                collection: true
      attribute :e_pub_fixed_layout_export_preference,
                Idml::Elements::EPubFixedLayoutExportPreference, collection: true

      xml do
        root "Preferences"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "ButtonPreference", to: :button_preference
        map_element "PrintPreference", to: :print_preference
        map_element "PrintBookletOption", to: :print_booklet_option
        map_element "PrintBookletPrintPreference",
                    to: :print_booklet_print_preference
        map_element "PageItemDefault", to: :page_item_default
        map_element "TransparencySetting", to: :transparency_setting
        map_element "BlendingSetting", to: :blending_setting
        map_element "DropShadowSetting", to: :drop_shadow_setting
        map_element "FeatherSetting", to: :feather_setting
        map_element "InnerShadowSetting", to: :inner_shadow_setting
        map_element "OuterGlowSetting", to: :outer_glow_setting
        map_element "InnerGlowSetting", to: :inner_glow_setting
        map_element "BevelAndEmbossSetting", to: :bevel_and_emboss_setting
        map_element "SatinSetting", to: :satin_setting
        map_element "DirectionalFeatherSetting",
                    to: :directional_feather_setting
        map_element "GradientFeatherSetting", to: :gradient_feather_setting
        map_element "OpacityGradientStop", to: :opacity_gradient_stop
        map_element "StrokeTransparencySetting",
                    to: :stroke_transparency_setting
        map_element "FillTransparencySetting", to: :fill_transparency_setting
        map_element "ContentTransparencySetting",
                    to: :content_transparency_setting
        map_element "FrameFittingOption", to: :frame_fitting_option
        map_element "StoryPreference", to: :story_preference
        map_element "TextFramePreference", to: :text_frame_preference
        map_element "TextPreference", to: :text_preference
        map_element "TextDefault", to: :text_default
        map_element "DictionaryPreference", to: :dictionary_preference
        map_element "AnchoredObjectDefault", to: :anchored_object_default
        map_element "AnchoredObjectSetting", to: :anchored_object_setting
        map_element "BaselineFrameGridOption", to: :baseline_frame_grid_option
        map_element "FootnoteOption", to: :footnote_option
        map_element "TextWrapPreference", to: :text_wrap_preference
        map_element "ContourOption", to: :contour_option
        map_element "MojikumiUiPreference", to: :mojikumi_ui_preference
        map_element "XMLImportPreference", to: :xml_import_preference
        map_element "XMLExportPreference", to: :xml_export_preference
        map_element "XMLPreference", to: :xml_preference
        map_element "ExportForWebPreference", to: :export_for_web_preference
        map_element "IndexOptions", to: :index_options
        map_element "IndexHeaderSetting", to: :index_header_setting
        map_element "TinDocumentDataObject", to: :tin_document_data_object
        map_element "ChapterNumberPreference", to: :chapter_number_preference
        map_element "DocumentPreference", to: :document_preference
        map_element "GridPreference", to: :grid_preference
        map_element "GuidePreference", to: :guide_preference
        map_element "MarginPreference", to: :margin_preference
        map_element "PasteboardPreference", to: :pasteboard_preference
        map_element "ViewPreference", to: :view_preference
        map_element "TransparencyPreference", to: :transparency_preference
        map_element "TransparencyDefaultContainerObject",
                    to: :transparency_default_container_object
        map_element "LayoutGridDataInformation",
                    to: :layout_grid_data_information
        map_element "StoryGridDataInformation", to: :story_grid_data_information
        map_element "CjkGridPreference", to: :cjk_grid_preference
        map_element "DataMerge", to: :data_merge
        map_element "DataMergeField", to: :data_merge_field
        map_element "DataMergeOption", to: :data_merge_option
        map_element "LayoutAdjustmentPreference",
                    to: :layout_adjustment_preference
        map_element "EPubExportPreference", to: :e_pub_export_preference
        map_element "HTMLExportPreference", to: :html_export_preference
        map_element "EPubFixedLayoutExportPreference",
                    to: :e_pub_fixed_layout_export_preference
      end
    end
  end
end
