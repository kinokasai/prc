open Shared.Types
open Ast
open Printf
open Helpers
open Shared.Exceptions
open Shared.Colors
open List
open Print
open Spider_monkey_ast

exception Empty_Id_List

let js_of_var id =
  Expression.Identifier(Loc.none,id);

let ast =
  let exp = js_of_var "lol" in
  let statement = Statement.Expression() in
  let statements = [] in
  let loc = Loc.none in
  let comments = [] in
  ast
