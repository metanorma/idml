# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for the package's `styles.xml` part.
    # Every child element from `reference-docs/schemas/package/Resources/Styles.rnc` is typed — generated
    # via `scripts/rnc_to_lutaml.rb` + `scripts/assemble_element.rb`.
    class Style < Lutaml::Model::Serializable
      include Idml::Part

      part_file "Resources/Styles.xml"

      attribute :dom_version, :string
      attribute :root_character_style_group, Idml::Elements::RootCharacterStyleGroup, collection: true
      attribute :character_style, Idml::Elements::CharacterStyle, collection: true
      attribute :style_export_tag_map, Idml::Elements::StyleExportTagMap, collection: true
      attribute :character_style_group, Idml::Elements::CharacterStyleGroup, collection: true
      attribute :root_paragraph_style_group, Idml::Elements::RootParagraphStyleGroup, collection: true
      attribute :paragraph_style, Idml::Elements::ParagraphStyle, collection: true
      attribute :paragraph_style_group, Idml::Elements::ParagraphStyleGroup, collection: true
      attribute :toc_style, Idml::Elements::TOCStyle, collection: true
      attribute :toc_style_entry, Idml::Elements::TOCStyleEntry, collection: true
      attribute :root_cell_style_group, Idml::Elements::RootCellStyleGroup, collection: true
      attribute :cell_style, Idml::Elements::CellStyle, collection: true
      attribute :cell_style_group, Idml::Elements::CellStyleGroup, collection: true
      attribute :root_table_style_group, Idml::Elements::RootTableStyleGroup, collection: true
      attribute :table_style, Idml::Elements::TableStyle, collection: true
      attribute :table_style_group, Idml::Elements::TableStyleGroup, collection: true
      attribute :root_object_style_group, Idml::Elements::RootObjectStyleGroup, collection: true
      attribute :object_style_group, Idml::Elements::ObjectStyleGroup, collection: true
      attribute :object_style, Idml::Elements::ObjectStyle, collection: true
      attribute :transform_attribute_option, Idml::Elements::TransformAttributeOption, collection: true
      attribute :flex_layout_attribute_option, Idml::Elements::FlexLayoutAttributeOption, collection: true
      attribute :object_style_export_tag_map, Idml::Elements::ObjectStyleExportTagMap, collection: true
      attribute :object_export_option, Idml::Elements::ObjectExportOption, collection: true
      attribute :text_frame_preference, Idml::Elements::TextFramePreference, collection: true
      attribute :baseline_frame_grid_option, Idml::Elements::BaselineFrameGridOption, collection: true
      attribute :anchored_object_setting, Idml::Elements::AnchoredObjectSetting, collection: true
      attribute :text_wrap_preference, Idml::Elements::TextWrapPreference, collection: true
      attribute :contour_option, Idml::Elements::ContourOption, collection: true
      attribute :story_preference, Idml::Elements::StoryPreference, collection: true
      attribute :frame_fitting_option, Idml::Elements::FrameFittingOption, collection: true
      attribute :transparency_setting, Idml::Elements::TransparencySetting, collection: true
      attribute :blending_setting, Idml::Elements::BlendingSetting, collection: true
      attribute :drop_shadow_setting, Idml::Elements::DropShadowSetting, collection: true
      attribute :feather_setting, Idml::Elements::FeatherSetting, collection: true
      attribute :inner_shadow_setting, Idml::Elements::InnerShadowSetting, collection: true
      attribute :outer_glow_setting, Idml::Elements::OuterGlowSetting, collection: true
      attribute :inner_glow_setting, Idml::Elements::InnerGlowSetting, collection: true
      attribute :bevel_and_emboss_setting, Idml::Elements::BevelAndEmbossSetting, collection: true
      attribute :satin_setting, Idml::Elements::SatinSetting, collection: true
      attribute :directional_feather_setting, Idml::Elements::DirectionalFeatherSetting, collection: true
      attribute :gradient_feather_setting, Idml::Elements::GradientFeatherSetting, collection: true
      attribute :opacity_gradient_stop, Idml::Elements::OpacityGradientStop, collection: true
      attribute :stroke_transparency_setting, Idml::Elements::StrokeTransparencySetting, collection: true
      attribute :fill_transparency_setting, Idml::Elements::FillTransparencySetting, collection: true
      attribute :content_transparency_setting, Idml::Elements::ContentTransparencySetting, collection: true
      attribute :object_style_object_effects_category_settings, Idml::Elements::ObjectStyleObjectEffectsCategorySettings, collection: true
      attribute :object_style_stroke_effects_category_settings, Idml::Elements::ObjectStyleStrokeEffectsCategorySettings, collection: true
      attribute :object_style_fill_effects_category_settings, Idml::Elements::ObjectStyleFillEffectsCategorySettings, collection: true
      attribute :object_style_content_effects_category_settings, Idml::Elements::ObjectStyleContentEffectsCategorySettings, collection: true
      attribute :text_frame_footnote_options_object, Idml::Elements::TextFrameFootnoteOptionsObject, collection: true
      attribute :trap_preset, Idml::Elements::TrapPreset, collection: true

      xml do
        root "Styles"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "RootCharacterStyleGroup", to: :root_character_style_group
        map_element "CharacterStyle", to: :character_style
        map_element "StyleExportTagMap", to: :style_export_tag_map
        map_element "CharacterStyleGroup", to: :character_style_group
        map_element "RootParagraphStyleGroup", to: :root_paragraph_style_group
        map_element "ParagraphStyle", to: :paragraph_style
        map_element "ParagraphStyleGroup", to: :paragraph_style_group
        map_element "TOCStyle", to: :toc_style
        map_element "TOCStyleEntry", to: :toc_style_entry
        map_element "RootCellStyleGroup", to: :root_cell_style_group
        map_element "CellStyle", to: :cell_style
        map_element "CellStyleGroup", to: :cell_style_group
        map_element "RootTableStyleGroup", to: :root_table_style_group
        map_element "TableStyle", to: :table_style
        map_element "TableStyleGroup", to: :table_style_group
        map_element "RootObjectStyleGroup", to: :root_object_style_group
        map_element "ObjectStyleGroup", to: :object_style_group
        map_element "ObjectStyle", to: :object_style
        map_element "TransformAttributeOption", to: :transform_attribute_option
        map_element "FlexLayoutAttributeOption", to: :flex_layout_attribute_option
        map_element "ObjectStyleExportTagMap", to: :object_style_export_tag_map
        map_element "ObjectExportOption", to: :object_export_option
        map_element "TextFramePreference", to: :text_frame_preference
        map_element "BaselineFrameGridOption", to: :baseline_frame_grid_option
        map_element "AnchoredObjectSetting", to: :anchored_object_setting
        map_element "TextWrapPreference", to: :text_wrap_preference
        map_element "ContourOption", to: :contour_option
        map_element "StoryPreference", to: :story_preference
        map_element "FrameFittingOption", to: :frame_fitting_option
        map_element "TransparencySetting", to: :transparency_setting
        map_element "BlendingSetting", to: :blending_setting
        map_element "DropShadowSetting", to: :drop_shadow_setting
        map_element "FeatherSetting", to: :feather_setting
        map_element "InnerShadowSetting", to: :inner_shadow_setting
        map_element "OuterGlowSetting", to: :outer_glow_setting
        map_element "InnerGlowSetting", to: :inner_glow_setting
        map_element "BevelAndEmbossSetting", to: :bevel_and_emboss_setting
        map_element "SatinSetting", to: :satin_setting
        map_element "DirectionalFeatherSetting", to: :directional_feather_setting
        map_element "GradientFeatherSetting", to: :gradient_feather_setting
        map_element "OpacityGradientStop", to: :opacity_gradient_stop
        map_element "StrokeTransparencySetting", to: :stroke_transparency_setting
        map_element "FillTransparencySetting", to: :fill_transparency_setting
        map_element "ContentTransparencySetting", to: :content_transparency_setting
        map_element "ObjectStyleObjectEffectsCategorySettings", to: :object_style_object_effects_category_settings
        map_element "ObjectStyleStrokeEffectsCategorySettings", to: :object_style_stroke_effects_category_settings
        map_element "ObjectStyleFillEffectsCategorySettings", to: :object_style_fill_effects_category_settings
        map_element "ObjectStyleContentEffectsCategorySettings", to: :object_style_content_effects_category_settings
        map_element "TextFrameFootnoteOptionsObject", to: :text_frame_footnote_options_object
        map_element "TrapPreset", to: :trap_preset
      end
    end
  end
end
