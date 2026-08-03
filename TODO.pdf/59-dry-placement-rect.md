# TODO PDF 59: DRY — shared placement_rect in Geometry

## Goal

Eliminate duplication between Pipeline#parent_clip_box and
RectangleRenderer.placement_box. Both compute the same thing:
transform bounds by ItemTransform, convert to PDF rect with Y-flip.

## Status: DONE

## What was implemented

`Geometry.placement_rect(bounds, item_transform_str, page_height)` —
single method that parses transform, applies to bounds, and converts
to PDF rect. Used by both RectangleRenderer and Pipeline.
