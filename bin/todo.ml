(* Layout *)

type rect = (int * int * int * int)
type colour = (int * int * int * int)
type border = bool * colour

type element =
  Box of rect * border * colour
  | Text of string * int            (* text and font size *)

type layout =
  VStack of element list list
  | HStack of element list list

let raylib_draw_rect _ _ = ()

let draw el = match el with
  | Box (r, _, c) -> raylib_draw_rect r c
  | Text -> ()

let render (root: layout) =
  match root with
  (* eventually have a responsive spacing algo here to change where rects are drawn *)
  | VStack (rows) -> List.iter (List.iter draw) rows
  | _ -> ()

(* Main *)

let grey = ( 100, 100, 100, 1)
let white = ( 255, 255, 255, 1)
let header = Box ((0, 0, 800, 100), (false, grey), grey)
let body = Box ((0, 100, 800, 540), (false, grey), white)

let x = VStack [[header]; [body]]

let setup () =
  Raylib.init_window 800 640 "snap-todo";
  Raylib.set_target_fps 60

let rec loop () =
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false -> 
      let open Raylib in
      begin_drawing ();
      clear_background Color.raywhite;
      draw_text "Congrats! You created your first window!" 190 200 20
        Color.lightgray;
      end_drawing ();
      loop ()

let () = setup () |> loop
