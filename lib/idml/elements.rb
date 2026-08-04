# frozen_string_literal: true

module Idml
  # Typed models for IDML elements that appear inside parts. Every
  # element class is generated from its `_Object` definition in the
  # RNC schemas at `reference-docs/schemas/package/` via
  # `scripts/rnc_to_lutaml.rb` + `scripts/assemble_element.rb`
  # (or `scripts/generate_all_objects.rb` for bulk generation).
  module Elements
    autoload :AnchoredObjectDefault,
             "idml/elements/pref_anchored_object_default"
    autoload :AnchoredObjectSetting, "idml/elements/anchored_object_setting"
    autoload :BaselineFrameGridOption,
             "idml/elements/baseline_frame_grid_option"
    autoload :BevelAndEmbossSetting, "idml/elements/bevel_and_emboss_setting"
    autoload :BlendingSetting, "idml/elements/blending_setting"
    autoload :ButtonPreference, "idml/elements/pref_button_preference"
    autoload :Bookmark, "idml/elements/bookmark"
    autoload :CellStyle, "idml/elements/cell_style"
    autoload :CellStyleGroup, "idml/elements/cell_style_group"
    autoload :ChapterNumberPreference,
             "idml/elements/pref_chapter_number_preference"
    autoload :CharacterStyle, "idml/elements/character_style"
    autoload :CharacterStyleGroup, "idml/elements/character_style_group"
    autoload :CharacterStyleRange, "idml/elements/character_style_range"
    autoload :CjkGridPreference, "idml/elements/pref_cjk_grid_preference"
    autoload :Color, "idml/elements/color"
    autoload :Content, "idml/elements/content"
    autoload :ContentTransparencySetting,
             "idml/elements/content_transparency_setting"
    autoload :ContourOption, "idml/elements/contour_option"
    autoload :DashedStrokeStyle, "idml/elements/dashed_stroke_style"
    autoload :DataMerge, "idml/elements/pref_data_merge"
    autoload :DataMergeField, "idml/elements/pref_data_merge_field"
    autoload :DataMergeOption, "idml/elements/pref_data_merge_option"
    autoload :DictionaryPreference, "idml/elements/pref_dictionary_preference"
    autoload :DirectionalFeatherSetting,
             "idml/elements/directional_feather_setting"
    autoload :DocumentObject, "idml/elements/document_object"
    autoload :DocumentPreference, "idml/elements/pref_document_preference"
    autoload :DottedStrokeStyle, "idml/elements/dotted_stroke_style"
    autoload :DropShadowSetting, "idml/elements/drop_shadow_setting"
    autoload :EPubExportPreference, "idml/elements/pref_e_pub_export_preference"
    autoload :EPubFixedLayoutExportPreference,
             "idml/elements/pref_e_pub_fixed_layout_export_preference"
    autoload :ExportForWebPreference,
             "idml/elements/pref_export_for_web_preference"
    autoload :FeatherSetting, "idml/elements/feather_setting"
    autoload :FillTransparencySetting, "idml/elements/fill_transparency_setting"
    autoload :FlexLayoutAttributeOption,
             "idml/elements/flex_layout_attribute_option"
    autoload :Font, "idml/elements/font"
    autoload :FontFamily, "idml/elements/font_family"
    autoload :FootnoteOption, "idml/elements/pref_footnote_option"
    autoload :FrameFittingOption, "idml/elements/frame_fitting_option"
    autoload :GraphicLine, "idml/elements/graphic_line"
    autoload :Gradient, "idml/elements/gradient"
    autoload :GradientFeatherSetting, "idml/elements/gradient_feather_setting"
    autoload :GradientStop, "idml/elements/gradient_stop"
    autoload :GridPreference, "idml/elements/pref_grid_preference"
    autoload :Group, "idml/elements/group"
    autoload :GuidePreference, "idml/elements/pref_guide_preference"
    autoload :HTMLExportPreference, "idml/elements/pref_html_export_preference"
    autoload :Hyperlink, "idml/elements/hyperlink"
    autoload :HyperlinkPageDestination,
             "idml/elements/hyperlink_page_destination"
    autoload :HyperlinkTextSource,
             "idml/elements/hyperlink_text_source"
    autoload :HyperlinkURLDestination,
             "idml/elements/hyperlink_url_destination"
    autoload :Image, "idml/elements/image"
    autoload :IndexHeaderSetting, "idml/elements/pref_index_header_setting"
    autoload :IndexOptions, "idml/elements/pref_index_options"
    autoload :Ink, "idml/elements/ink"
    autoload :InnerGlowSetting, "idml/elements/inner_glow_setting"
    autoload :InnerShadowSetting, "idml/elements/inner_shadow_setting"
    autoload :LayoutAdjustmentPreference,
             "idml/elements/pref_layout_adjustment_preference"
    autoload :LayoutGridDataInformation,
             "idml/elements/pref_layout_grid_data_information"
    autoload :Layer, "idml/elements/layer"
    autoload :Link, "idml/elements/link"
    autoload :MarginPreference, "idml/elements/pref_margin_preference"
    autoload :MasterSpreadObject, "idml/elements/master_spread_object"
    autoload :MixedInk, "idml/elements/mixed_ink"
    autoload :MixedInkGroup, "idml/elements/mixed_ink_group"
    autoload :MojikumiUiPreference, "idml/elements/pref_mojikumi_ui_preference"
    autoload :ObjectExportOption, "idml/elements/object_export_option"
    autoload :ObjectStyle, "idml/elements/object_style"
    autoload :ObjectStyleContentEffectsCategorySettings,
             "idml/elements/object_style_content_effects_category_settings"
    autoload :ObjectStyleExportTagMap,
             "idml/elements/object_style_export_tag_map"
    autoload :ObjectStyleFillEffectsCategorySettings,
             "idml/elements/object_style_fill_effects_category_settings"
    autoload :ObjectStyleGroup, "idml/elements/object_style_group"
    autoload :ObjectStyleObjectEffectsCategorySettings,
             "idml/elements/object_style_object_effects_category_settings"
    autoload :ObjectStyleStrokeEffectsCategorySettings,
             "idml/elements/object_style_stroke_effects_category_settings"
    autoload :OpacityGradientStop, "idml/elements/opacity_gradient_stop"
    autoload :OuterGlowSetting, "idml/elements/outer_glow_setting"
    autoload :PageItemDefault, "idml/elements/pref_page_item_default"
    autoload :Page, "idml/elements/page"
    autoload :ParagraphStyle, "idml/elements/paragraph_style"
    autoload :ParagraphStyleGroup, "idml/elements/paragraph_style_group"
    autoload :ParagraphStyleRange, "idml/elements/paragraph_style_range"
    autoload :PasteboardPreference, "idml/elements/pref_pasteboard_preference"
    autoload :PastedSmoothShade, "idml/elements/pasted_smooth_shade"
    autoload :PathGeometry, "idml/elements/path_geometry"
    autoload :PathPointArray, "idml/elements/path_point_array"
    autoload :PathPointType, "idml/elements/path_point_type"
    autoload :Polygon, "idml/elements/polygon"
    autoload :PrintBookletOption, "idml/elements/pref_print_booklet_option"
    autoload :PrintBookletPrintPreference,
             "idml/elements/pref_print_booklet_print_preference"
    autoload :PrintPreference, "idml/elements/pref_print_preference"
    autoload :Properties, "idml/elements/properties"
    autoload :GeometryPathType, "idml/elements/geometry_path_type"
    autoload :Rectangle, "idml/elements/rectangle"
    autoload :RootCellStyleGroup, "idml/elements/root_cell_style_group"
    autoload :RootCharacterStyleGroup,
             "idml/elements/root_character_style_group"
    autoload :RootObjectStyleGroup, "idml/elements/root_object_style_group"
    autoload :RootParagraphStyleGroup,
             "idml/elements/root_paragraph_style_group"
    autoload :RootTableStyleGroup, "idml/elements/root_table_style_group"
    autoload :SatinSetting, "idml/elements/satin_setting"
    autoload :SpreadObject, "idml/elements/spread_object"
    autoload :StoryGridDataInformation,
             "idml/elements/pref_story_grid_data_information"
    autoload :StoryInner, "idml/elements/story_inner"
    autoload :StoryPreference, "idml/elements/story_preference"
    autoload :StripedStrokeStyle, "idml/elements/striped_stroke_style"
    autoload :StrokeStyle, "idml/elements/stroke_style"
    autoload :StrokeTransparencySetting,
             "idml/elements/stroke_transparency_setting"
    autoload :StyleExportTagMap, "idml/elements/style_export_tag_map"
    autoload :Swatch, "idml/elements/swatch"
    autoload :TOCStyle, "idml/elements/toc_style"
    autoload :TOCStyleEntry, "idml/elements/toc_style_entry"
    autoload :Table, "idml/elements/table"
    autoload :TableCell, "idml/elements/table_cell"
    autoload :TableRow, "idml/elements/table_row"
    autoload :TableStyle, "idml/elements/table_style"
    autoload :TableStyleGroup, "idml/elements/table_style_group"
    autoload :TextDefault, "idml/elements/pref_text_default"
    autoload :TextFrame, "idml/elements/text_frame"
    autoload :TextFrameFootnoteOptionsObject,
             "idml/elements/text_frame_footnote_options_object"
    autoload :TextFramePreference, "idml/elements/text_frame_preference"
    autoload :TextPreference, "idml/elements/pref_text_preference"
    autoload :TextWrapPreference, "idml/elements/text_wrap_preference"
    autoload :TinDocumentDataObject,
             "idml/elements/pref_tin_document_data_object"
    autoload :Tint, "idml/elements/tint"
    autoload :TransformAttributeOption,
             "idml/elements/transform_attribute_option"
    autoload :TransparencyDefaultContainerObject,
             "idml/elements/pref_transparency_default_container_object"
    autoload :TransparencyPreference,
             "idml/elements/pref_transparency_preference"
    autoload :TransparencySetting, "idml/elements/transparency_setting"
    autoload :TrapPreset, "idml/elements/trap_preset"
    autoload :ViewPreference, "idml/elements/pref_view_preference"
    autoload :XMLExportPreference, "idml/elements/pref_xml_export_preference"
    autoload :XMLImportPreference, "idml/elements/pref_xml_import_preference"
    autoload :XMLPreference, "idml/elements/pref_xml_preference"
    autoload :XmlElement, "idml/elements/xml_element"
    autoload :XmlExportMap, "idml/elements/xml_export_map"
    autoload :XmlImportMap, "idml/elements/xml_import_map"
    autoload :XmlStory, "idml/elements/xml_story"
    autoload :XmlTag, "idml/elements/xml_tag"
  end
end
