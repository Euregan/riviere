import chokidar from 'chokidar'
import express from 'express'

const app = express()

app.use(express.json())

const addRoute = (path, event) => {
  const route = `/${path.split('.')[0]}`

  import(`./${path}`)
    .then((handler) => {
      app.all(route, handler.default)
      console.log(`Added route ${route}`)
    })
    .catch((error) => {
      console.error(`Failed to add route ${route}`)
      console.error(error)
    })
}

const port = 3000
app.listen(port, () => {
  console.log(`API listening on port ${port}`)
})

chokidar
  .watch('./api')
  .on('add', addRoute) //.on('unlink', refreshRoutes)
  .on('change', addRoute) //.on('unlink', refreshRoutes)
