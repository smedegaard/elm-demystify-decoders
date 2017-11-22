module Exercise10 exposing (decoder, Person, PersonDetails, Role(..))

import Json.Decode exposing (andThen, fail, succeed, Decoder, list, field, map2, map3, string)


{- Let's try and do a complicated decoder, this time. No worries, nothing new
   here: applying the techniques you've used in the previous decoders should
   help you through this one.

   A couple of pointers:
    - try working "inside out". Write decoders for the details and role first
    - combine those decoders + the username and map them into the Person constructor
    - finally, wrap it all together to build it into a list of people


   Example input:

        [ { "username": "Phoebe"
          , "role": "regular"
          , "details":
            { "registered": "yesterday"
            , "aliases": [ "Phoebs" ]
            }
          }
        ]
-}


type alias Person =
    { username : String
    , role : Role
    , details : PersonDetails
    }


type alias PersonDetails =
    { registered : String
    , aliases : List String
    }


type Role
    = Newbie
    | Regular
    | OldFart


decoder : Decoder (List Person)
decoder =
    list (personDecoder)

detailsDecoder : Decoder PersonDetails
detailsDecoder =
    map2 PersonDetails
        (field "registered" string)
        (field "aliases" (list string))

roleDecoder : Decoder Role
roleDecoder =
    string
        |> andThen
            (\string ->
                let str =
                  String.toLower string
                in
                case str of
                    "newbie" ->
                        succeed Newbie

                    "regular" ->
                        succeed Regular

                    "oldfart" ->
                        succeed OldFart

                    _ ->
                        fail "Invalid Role"
            )

personDecoder : Decoder Person
personDecoder =
  map3 Person
    (field "username" string)
    (field "role" roleDecoder)
    (field "details" detailsDecoder)



{- Once you think you're done, run the tests for this exercise from the root of
   the project:

   - If you have installed `elm-test` globally:
        `elm test tests/Exercise10`

   - If you have installed locally using `npm`:
        `npm run elm-test tests/Exercise10`

   - If you have installed locally using `yarn`:
        `yarn elm-test tests/Exercise10`
-}
