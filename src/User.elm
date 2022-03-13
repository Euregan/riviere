module User exposing (User(..), login)

import Json.Decode as Decode
import Jwt exposing (JwtError(..))


type alias AuthenticatedUser =
    { jwt : String
    , id : String
    , name : String
    , email : String
    }


type User
    = Visitor
    | User AuthenticatedUser


decoder : String -> Decode.Decoder User
decoder jwt =
    Decode.map3
        (\id name email ->
            User
                { id = id
                , name = name
                , email = email
                , jwt = jwt
                }
        )
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "email" Decode.string)


login : String -> Result JwtError User
login jwt =
    Jwt.decodeToken
        (decoder jwt)
        jwt
