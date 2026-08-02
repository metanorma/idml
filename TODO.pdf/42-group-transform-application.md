# TODO PDF 42: Group transform application

## Goal

Apply a Group's ItemTransform to all child page items during rendering.
Currently GroupRenderer renders children without the Group's transform.

## Acceptance criteria

- [ ] GroupRenderer applies Group#item_transform via `cm` operator.
- [ ] Child items rendered within the transformed coordinate space.
- [ ] Nested groups (Group within Group) handled recursively.
- [ ] Spec: render a Group with offset transform, verify children shift.

## Dependencies

- TODO 26 (renderer registry).
