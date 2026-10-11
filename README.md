# Arrakis Base Board

Shared planning board for Dune: Awakening bases. Equilateral triangles and squares
with the same edge length, snapping edge to edge, live for everyone who has the link.
No accounts.

- Live page: https://travioman.github.io/base-board/
- Each board is a room in the URL hash, e.g. `#spice-crew`. Opening the page with no
  hash makes a fresh room. Share the full URL.
- Draw mode: sketch an outline, the board fills it with squares and triangles
  (choose Mixed / Squares only / Triangles only), then Build it.
- Anyone with the link can edit. Rooms cap at 3000 pieces.

## Backend

Two tables (`board_pieces`, `board_notes`) with open row-level-security policies live
in the `ourplace-scratch` Supabase project (the free tier allows two projects and both
slots were taken). The publishable key in `index.html` is public by design.
If that project is ever rebuilt or deleted, re-run the SQL in `schema.sql`.
