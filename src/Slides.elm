module Slides exposing (slides)

import Deck exposing (Deck, Slide(..))
import Extension exposing (Extension(..))
import GenealogyTree
import Html
import Slide.Application as Application exposing (Application(..))
import Slide.Repository.File as File exposing (File(..))
import Slide.Repository.FileTree as FileTree exposing (File(..))
import Slide.Terminal as Terminal exposing (Color(..), Line(..))
import Slide.Text as Text exposing (Text(..))


slides : Deck
slides =
    Deck.init
        (Deck.Text <|
            Title
                { title = "Comment créer un site incassable"
                , subtitle = Just "Ou comment éviter les erreurs côté client"
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
                    , "Il y aura du code approximatif 😬"
                    ]
                }
        , Application <| FakeBrowser "https://unbreakable.com" GenealogyTree.display
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
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
        parents: []
      }} />
    ...
  </div>
}"""
                }
            )
        , Terminal ( "valentin", [ Command [ ( Default, "npm run build" ) ], Result [ ( Red, "Argument of type '{ naem: string; picture: string; }' is not assignable to parameter of type 'Person'.\n  Object literal may only specify known properties, and 'naem' does not exist in type 'Person'." ) ] ] )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , File "webpack.config.js" JavaScript
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
                    , File "webpack.config.js" JavaScript
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
import { zod } from "zod"

interface Person {
  name: string;
  picture: string;
  parents: Person[];
}

const Person: zod.ZodSchema<Person> = zod.lazy(() =>
  zod.object({
    name: zod.string(),
    picture: zod.string(),
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
                    , File "webpack.config.js" JavaScript
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
import { zod } from "zod"

interface Person {
  name: string;
  picture: string;
  parents: Person[];
}

const Person: zod.ZodSchema<Person> = zod.lazy(() =>
  zod.object({
    name: zod.string(),
    picture: zod.string(),
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
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , File "webpack.config.js" JavaScript
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
import { zod } from "zod"

interface Person {
  name: string;
  picture: string;
  parents: Person[];
}

const Person: zod.ZodSchema<Person> = zod.lazy(() =>
  zod.object({
    name: zod.string(),
    picture: zod.string(),
    parents: zod.array(Person),
  })
)

const App = () => {
  const { data: tree }: {} = useSWR<Person>(..., url =>
    fetch(url)
      .then(response => response.json())
      .then(person => Person.parse(person))
  )

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
        , Terminal ( "valentin", [ Command [ ( Default, "npm run build" ) ], Result [ ( Green, "All good chief 👍" ) ] ] )
        , Application <| FakeBrowser "https://unbreakable.com" (Html.text "")
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , File "webpack.config.js" JavaScript
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        , File "api.ts" TypeScript
                        ]
                    ]
              }
            , SelectedFile
                { name = "api.ts"
                , extension = TypeScript
                , content = """import { useState, useEffect } from 'react'
import { zod } from "zod"

interface Person {
  name: string;
  picture: string;
  parents: Person[];
}

const Person: zod.ZodSchema<Person> = zod.lazy(() =>
  zod.object({
    name: zod.string(),
    picture: zod.string(),
    parents: zod.array(Person),
  })
)

type ApiPerson = Person | Error

export const useGenealogyTree = () => {
  const [person, setPerson] = useState(null)
  const [error, setError] = useState(null)

  useEffect(() => {
    fetch(...)
      .then(response => response.json())
      .then(person => Person.parse(person))
      .then(person => setPerson(person))
      .catch(error => setError(error))
  }, [])

  if (error) {
    return error
  }

  return person
}"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , File "webpack.config.js" JavaScript
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        , File "api.ts" TypeScript
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.tsx"
                , extension = TSX
                , content = """import { useGenealogyTree } from './api'

const App = () => {
  const treeOrError = useGenealogyTree()

  if (isError(treeOrError)) return <div>oh no</div>
  if (!treeOrError) return <div>Récupération de votre généalogie...</div>

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
                    , File "webpack.config.js" JavaScript
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        , File "api.ts" TypeScript
                        ]
                    ]
              }
            , SelectedFile
                { name = "api.ts"
                , extension = TypeScript
                , content = """import { useState, useEffect } from 'react'
import { zod } from "zod"

interface Person {
  name: string;
  picture: string;
  parents: Person[];
}

const Person: zod.ZodSchema<Person> = zod.lazy(() =>
  zod.object({
    name: zod.string(),
    picture: zod.string(),
    parents: zod.array(Person),
  })
)

interface ApiPerson extends Person {
  type: 'person'
}

interface ApiError extends Error {
  type: 'error'
}

type ApiPersonResult = ApiPerson | ApiError

export const useGenealogyTree = () => {
  const [person, setPerson] = useState(null)
  const [error, setError] = useState(null)

  useEffect(() => {
    fetch(...)
      .then(response => response.json())
      .then(person => Person.parse(person))
      .then(person => setPerson({...person, type: 'person'}))
      .catch(error => setError({...error, type: 'error'}))
  }, [])

  if (error) {
    return error
  }

  return person
}"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , File "webpack.config.js" JavaScript
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        , File "api.ts" TypeScript
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.tsx"
                , extension = TSX
                , content = """import { useGenealogyTree } from './api'

const App = () => {
  const treeOrError = useGenealogyTree()

  switch (treeOrError.type) {
    case 'error':
      return <div>oh no</div>
    case 'person':
      return <div>
      ...
        <Person person={person} />
      ...
      </div>
    default:
      return <div>Récupération de votre généalogie...</div>
  }
}"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , File "webpack.config.js" JavaScript
                    , File "tsconfig.json" JSON
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        , File "api.ts" TypeScript
                        ]
                    ]
              }
            , SelectedFile
                { name = "tsconfig.json"
                , extension = JSON
                , content = """{
  "compilerOptions": {
    "strict": true
  }
}"""
                }
            )
        , Repository
            ( { name = "unbreakable-ish"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , File "webpack.config.js" JavaScript
                    , File "tsconfig.json" JSON
                    , Directory "src"
                        [ File "App.tsx" TSX
                        , File "Person.tsx" TSX
                        , File "api.ts" TypeScript
                        ]
                    ]
              }
            , SelectedFile
                { name = "App.tsx"
                , extension = TSX
                , content = """import { useGenealogyTree } from './api'

const App = () => {
  const treeOrError = useGenealogyTree()

  switch (treeOrError.type) {
    case 'error':
      return <div>oh no</div>
    case 'person':
      return <div>
      ...
        <Person person={person} />
      ...
      </div>
    default:
      return <div>Récupération de votre généalogie...</div>
  }
}"""
                }
            )
        , Deck.Text <|
            Text.Text
                { title = "Limitations"
                , content =
                    []
                }
        , Deck.Text <|
            Text.Text
                { title = "Limitations"
                , content =
                    [ "Beaucoup d'outils différents"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Limitations"
                , content =
                    [ "Beaucoup d'outils différents"
                    , "Du boilerplate à maintenir"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Limitations"
                , content =
                    [ "Beaucoup d'outils différents"
                    , "Du boilerplate à maintenir"
                    , "Toutes les librairies ne sont pas typées"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Limitations"
                , content =
                    [ "Beaucoup d'outils différents"
                    , "Du boilerplate à maintenir"
                    , "Toutes les librairies ne sont pas typées"
                    , "Le but de TypeScript n'est pas de prévenir des erreurs"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Limitations"
                , content =
                    [ "Beaucoup d'outils différents"
                    , "Du boilerplate à maintenir"
                    , "Toutes les librairies ne sont pas typées"
                    , "Le but de TypeScript n'est pas de prévenir des erreurs"
                    , "Flaky tests"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Quelques alternatives"
                , content =
                    []
                }
        , Deck.Text <|
            Text.Text
                { title = "Quelques alternatives"
                , content =
                    [ "next" ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Quelques alternatives"
                , content =
                    [ "next"
                    , "Rome / Vite"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Elm"
                , content = []
                }
        , Deck.Text <|
            Text.Text
                { title = "Elm"
                , content =
                    [ "Un seul outil"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Elm"
                , content =
                    [ "Un seul outil"
                    , "Pas de boilerplate"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Elm"
                , content =
                    [ "Un seul outil"
                    , "Pas de boilerplate"
                    , "Toutes les librairies sont typées"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Elm"
                , content =
                    [ "Un seul outil"
                    , "Pas de boilerplate"
                    , "Toutes les librairies sont typées"
                    , "Le but d'Elm est de prévenir des erreurs"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Elm"
                , content =
                    [ "Un seul outil"
                    , "Pas de boilerplate"
                    , "Toutes les librairies sont typées"
                    , "Le but d'Elm est de prévenir des erreurs"
                    , "Pas de flaky test, jamais"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Elm"
                , content =
                    [ "Un seul outil"
                    , "Pas de boilerplate"
                    , "Toutes les librairies sont typées"
                    , "Le but d'Elm est de prévenir des erreurs"
                    , "Pas de flaky test, jamais"
                    , "Meilleur tree shaking"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Elm"
                , content =
                    [ "Un seul outil"
                    , "Pas de boilerplate"
                    , "Toutes les librairies sont typées"
                    , "Le but d'Elm est de prévenir des erreurs"
                    , "Pas de flaky test, jamais"
                    , "Meilleur tree shaking"
                    , "Rapide à compiler"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Elm"
                , content =
                    [ "Un seul outil"
                    , "Pas de boilerplate"
                    , "Toutes les librairies sont typées"
                    , "Le but d'Elm est de prévenir des erreurs"
                    , "Pas de flaky test, jamais"
                    , "Meilleur tree shaking"
                    , "Rapide à compiler"
                    , "Mature"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Elm"
                , content =
                    [ "Un seul outil"
                    , "Pas de boilerplate"
                    , "Toutes les librairies sont typées"
                    , "Le but d'Elm est de prévenir des erreurs"
                    , "Pas de flaky test, jamais"
                    , "Meilleur tree shaking"
                    , "Rapide à compiler"
                    , "Mature"
                    , "Meilleurs messages d'erreur"
                    ]
                }
        , Deck.Text <|
            Text.Text
                { title = "Elm"
                , content =
                    [ "Un seul outil"
                    , "Pas de boilerplate"
                    , "Toutes les librairies sont typées"
                    , "Le but d'Elm est de prévenir des erreurs"
                    , "Pas de flaky test, jamais"
                    , "Meilleur tree shaking"
                    , "Rapide à compiler"
                    , "Mature"
                    , "Meilleurs messages d'erreur"
                    , "Pas de BC surprise"
                    ]
                }
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "elm.json" JSON
                    , Directory "src"
                        [ File "Main.elm" Elm
                        ]
                    ]
              }
            , SelectedFile
                { name = "Main.elm"
                , extension = Elm
                , content = """
type Msg
    = GetGenealogyTree
    | TreeReceived (Result Http.Error Person)

type alias Person =
    { name: String
    , picture: String
    , parents: List Person
    }

type Model
    = Nothing
    | Error Http.Error
    | Person Person

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetGenealogyTree ->
            ( model, Http.get
                { url = ...
                , expect = Http.expectJson TreeReceived treeDecoder
                } )

        TreeReceived (Err error) ->
            ( { model | error = error }, Cmd.none )

        TreeReceived (Ok tree) ->
            ( tree, Cmd.none )

view : Model -> Html Msg
view model =
    case model of
        Nothing ->
            div [] [ text "Récupération de votre généalogie..." ]
        Error error ->
            div [] [ text "oh no" ]
        Person person ->
            div []
              [ img [ src person.picture ] []
              , text person.name
              ]"""
                }
            )
        , Deck.Text <|
            Title
                { title = "Questions ?"
                , subtitle = Nothing
                }
        ]
