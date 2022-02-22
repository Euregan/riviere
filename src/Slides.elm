module Slides exposing (slides)

import Application exposing (Application(..))
import Deck exposing (Deck, Slide(..))
import Extension exposing (Extension(..))
import File exposing (File(..))
import FileTree exposing (File(..))
import GenealogyTree
import Html
import Terminal exposing (Color(..), Line(..))
import Text exposing (Text(..))


slides : Deck
slides =
    Deck.init
        (Deck.Text <|
            Title
                { title = "Making an unbreakable website"
                , subtitle = Just "Or how to avoid clientside errors"
                }
        )
        [ Deck.Text <|
            Text.Text
                { title = "DISCLAIMER"
                , content =
                    []
                }
        , Deck.Text <|
            Text.Text
                { title = "DISCLAIMER"
                , content =
                    [ "Je vais parler du front" ]
                }
        , Deck.Text <|
            Text.Text
                { title = "DISCLAIMER"
                , content =
                    [ "Je vais parler du front"
                    , "Je ne couvrirai pas certains problèmes"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "DISCLAIMER"
                , content =
                    [ "Je vais parler du front"
                    , "Je ne couvrirai pas certains problèmes"
                    , "Il y a des problèmes ingérables"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "DISCLAIMER"
                , content =
                    [ "Je vais parler du front"
                    , "Je ne couvrirai pas certains problèmes"
                    , "Il y a des problèmes ingérables"
                    , "Oui, il y aura des désavantages"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "DISCLAIMER"
                , content =
                    [ "Je vais parler du front"
                    , "Je ne couvrirai pas certains problèmes"
                    , "Il y a des problèmes ingérables"
                    , "Oui, il y aura des désavantages"
                    , "Oui, il y aura du code approximatif 😬"
                    ]
                }
        , Application <| FakeBrowser "https://unbreakable.com" GenealogyTree.display
        , Deck.Text <|
            Title
                { title = "Assister l'humain"
                , subtitle = Nothing
                }
        , Repository
            ( { name = "unbreakable"
              , files = []
              }
            , None
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    ]
              }
            , None
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "index.js" JavaScript
                        ]
                    ]
              }
            , None
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "index.js" JavaScript
                        ]
                    ]
              }
            , SelectedFile
                { name = "index.js"
                , extension = JavaScript
                , content = """$("#btn-add-parent").click(function(event) {
    const form = $('<form class="create"><label>Prénom<input/></label> ... </form>');
    form.submit(function() {...});
    $(event.target).empty();
    $(event.target).append(form);
});"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "index.js" JavaScript
                        ]
                    ]
              }
            , None
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.jsx" JSX
                        , File "Person.jsx" JSX
                        ]
                    ]
              }
            , None
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.jsx" JSX
                        , File "Person.jsx" JSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.jsx"
                , extension = JSX
                , content = """import { useState, useEffect } from 'react'

const App = () => {
  const [tree, setTree] = useState(null)

  useEffect(() => {
    fetch(...)
      .then(tree => setTree(tree))
  }, [])

  if (!tree) return <div>Récupération de votre généalogie...</div>

  const addParent = () => {...}

  return <div>
    ...
      <Person person={person} />
    ...
  </div>
}"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.jsx" JSX
                        , File "Person.jsx" JSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "Person.jsx"
                , extension = JSX
                , content = """const Person = ({person}) => <div><img src={person.picture}/>{person.name}</div>"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.jsx" JSX
                        , File "Person.jsx" JSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "Person.jsx"
                , extension = JSX
                , content = """import PropTypes from 'prop-types'

const Person = ({person}) => <div><img src={person.picture}/>{person.name}</div>

Person.propTypes = {
  name: PropTypes.string,
  picture: PropTypes.string
}"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.jsx" JSX
                        , File "Person.jsx" JSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.jsx"
                , extension = JSX
                , content = """import { useState, useEffect } from 'react'

const App = () => {
  const [tree, setTree] = useState(null)

  useEffect(() => {
    fetch(...)
      .then(tree => setTree(tree))
  }, [])

  if (!tree) return <div>Récupération de votre généalogie...</div>

  const addParent = () => {...}

  return <div>
    ...
      <Person person={person} />
    ...
  </div>
}"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.jsx" JSX
                        , File "Person.jsx" JSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.jsx"
                , extension = JSX
                , content = """import useSWR from 'swr'

const App = () => {
  const { data: tree, error } = useSWR(...)

  if (error) return <div>oh no</div>
  if (!tree) return <div>Récupération de votre généalogie...</div>

  const addParent = () => {...}

  return <div>
    ...
      <Person person={person} />
    ...
  </div>
}"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.tsx"
                , extension = TSX
                , content = """import useSWR from 'swr'

const App = () => {
  const { data: tree, error } = useSWR(...)

  if (error) return <div>oh no</div>
  if (!tree) return <div>Récupération de votre généalogie...</div>

  const addParent = () => {...}

  return <div>
    ...
      <Person person={person} />
    ...
  </div>
}"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.tsx"
                , extension = TSX
                , content = """import useSWR from 'swr'

interface Tree {
  ...
}

const App = () => {
  const { data: tree, error }: {} = useSWR<Tree>(...)

  if (error) return <div>oh no</div>
  if (!tree) return <div>Récupération de votre généalogie...</div>

  const addParent = () => {...}

  return <div>
    ...
      <Person person={person} />
    ...
  </div>
}"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "Person.tsx"
                , extension = TSX
                , content = """interface Person {
  name: string;
  picture: string;
  orphan: boolean;
  parents: Person[];
}

const Person = ({person}: {person: Person}) => <div><img src={person.picture}/>{person.name}</div>"""
                }
            )
        , Application <| FakeBrowser "https://unbreakable.com" GenealogyTree.display
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "Person.tsx"
                , extension = TSX
                , content = """interface Person {
  name: string;
  picture: string;
  orphan: boolean;
  parents: Person[];
}

const Person = ({person}: {person: Person}) => <div><img src={person.picture}/>{person.name}</div>"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.tsx"
                , extension = TSX
                , content = """import useSWR from 'swr'

interface Tree {
  ...
}

const App = () => {
  const { data: tree, error }: {} = useSWR<Tree>(...)

  if (error) return <div>oh no</div>
  if (!tree) return <div>Récupération de votre généalogie...</div>

  const addParent = () => {...}

  return <div>
    ...
      <Person person={person} />
    ...
  </div>
}"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.tsx"
                , extension = TSX
                , content = """import useSWR from 'swr'

interface Tree {
  ...
}

const App = () => {
  const { data: tree, error }: {} = useSWR<Tree>(...)

  if (error) return <div>oh no</div>
  if (!tree) return <div>Récupération de votre généalogie...</div>

  const addParent = () => {...}

  return <div>
    ...
      <Person person={{
        naem: 'Alice Allard',
        picture: 'alice.png',
        orphan: false,
        parents: []
      }} />
    ...
  </div>
}"""
                }
            )
        , Terminal ( "valentin", [ Command [ ( Default, "npm run build" ) ], Result [ ( Red, "Argument of type '{ naem: string; picture: string; orphan: false; }' is not assignable to parameter of type 'Person'.\n  Object literal may only specify known properties, and 'naem' does not exist in type 'Person'." ) ] ] )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.tsx"
                , extension = TSX
                , content = """import useSWR from 'swr'
import { zod } from "zod";

interface Person {
  name: string;
  picture: string;
  orphan: boolean;
  parents: Person[];
}

const Person: zod.ZodSchema<Person> = zod.lazy(() =>
  zod.object({
    name: zod.string(),
    picture: zod.string(),
    orphan: zod.boolean(),
    parents: zod.array(Person),
  })
)

const App = () => {
  const { data: tree, error }: {} = useSWR<Tree>(...)

  if (error) return <div>oh no</div>
  if (!tree) return <div>Récupération de votre généalogie...</div>

  const addParent = () => {...}

  return <div>
  ...
    <Person person={person} />
  ...
  </div>
}"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.tsx"
                , extension = TSX
                , content = """import useSWR from 'swr'
import { zod } from "zod";

interface Person {
  name: string;
  picture: string;
  orphan: boolean;
  parents: Person[];
}

const Person: zod.ZodSchema<Person> = zod.lazy(() =>
  zod.object({
    name: zod.string(),
    picture: zod.string(),
    orphan: zod.boolean(),
    parents: zod.array(Person),
  })
)

const App = () => {
  const { data: tree, error }: {} = useSWR<Person>(..., url =>
    fetch(url)
      .then(response => response.json())
      .then(person => Person.parse(person))
  )

  if (error) return <div>oh no</div>
  if (!tree) return <div>Récupération de votre généalogie...</div>

  const addParent = () => {...}

  return <div>
  ...
    <Person person={person} />
  ...
  </div>
}"""
                }
            )
        ]
