const express = require('express')
const bodyParser = require('body-parser')
const proc = require('./lib/proc')
const path = require('path')

const PORT = 3000
const app = express()

function tick() {
    return process.nextTick(proc.tick)
}

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))
app.use(express.static(`${__dirname}/build`))

app.get('/', (req, res) => {
    res.sendFile(path.join(process.cwd(), 'build/index.html'))
})

app.post('/api/stage', (req, res) => {
    const data = proc.stage()
    res.send(JSON.stringify({ data }))
})
app.post('/api/commit', (req, res) => {
    const data = proc.commit()
    res.send(JSON.stringify({ data }))
})
app.post('/api/abort', (req, res) => {
    const data = proc.abort()
    res.send(JSON.stringify({ data }))
})


app.listen(PORT, () => {
    console.log(`Listening at http://localhost:${PORT}`)
})
