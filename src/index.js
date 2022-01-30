import './prism/prism.js'
import './prism/prism.css'

import { Elm } from './Main.elm'
import './app.css'

Elm.Main.init({
  node: document.getElementById('root')
})
