open JsonCombinators

let rec at = (key_path, decoder) =>
    switch key_path {
    | list{key} => Json.Decode.field(key, decoder)
    | list{first, ...rest} => Json.Decode.field(first, at(rest, decoder))
    | list{} =>
      \"@@"(
        raise,
        Invalid_argument("Expected key_path to contain at least one element"),
      )
    }


let decodeString = (decoder, string) =>
    try {
      let value = Js.Json.parseExn(string)
      JsonCombinators.Json.Decode.decode(value,decoder)
    } catch {
    /* | JsException e -> Error ("Given an invalid JSON: " ^ e) */
    | _ => Error("Invalid JSON string")
    }

let map2 = (f, decode1, decode2, json) => f(decode1(json), decode2(json))