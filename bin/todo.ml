(* dodgy globals *)
(* let font = Raylib.load_font_ex "bin/Inter-Regular.ttf" 32 (Raylib.ptr_of_int 0) 0 *)


(* -- Layout *)

type rect = (int * int * int * int)
type colour = (int * int * int * int)
type border = bool * colour

type element =
  Rect of rect * border * Raylib.Color.t
  | Text of int * int * string * int            (* text and font size *)

type layout =
  VStack of layout list
  | HStack of layout list
  | Box of element list


(* Components *)

(* Button / Text input / Icon / ListBox *)

let pos = Raylib.Vector2.create 10.0 10.0
let draw el = match el with
  | Rect ((x, y, w, h), _, c) -> Raylib.draw_rectangle x y w h c
  | Text (x, y, text, font_size) -> Raylib.draw_text text x y font_size Raylib.Color.black

let rec render (root: layout) =
  match root with
  (* eventually have a responsive spacing algo here to change where rects are drawn *)
  | VStack (rows) -> List.iter render rows
  | HStack (rows) -> List.iter render rows
  | Box (els) -> List.iter draw els

(* -- Main *)

let grey = ( 100, 100, 100, 1)
let white = ( 255, 255, 255, 1)

(* let x = 
  VStack [[header; Text (360, 15, "snap-todo", 15)]; [body]] *)

let x =
  VStack [
    Box [Rect ((0, 0, 800, 50), (false, grey), Raylib.Color.darkgreen)] ;
    Box [Rect ((0, 100, 800, 590), (false, grey), Raylib.Color.raywhite)]
  ]


let setup () =
  Raylib.init_window 800 640 "snap-todo";
  Raylib.set_target_fps 60;
  ()

let rec loop () =
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false -> 
      let open Raylib in
      begin_drawing ();
      clear_background Color.raywhite;
      render x;
      end_drawing ();
      loop ()

let () = setup () |> loop
