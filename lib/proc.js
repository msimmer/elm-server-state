let state = {
    count: []
}
let proposal = { ...state }

function* cycle() {
    let i = -1
    while (i < 100) {
        i++
        yield i
    }
}

const cycleIterator = cycle()

function stage() {
    const { count } = state
    proposal = { ...state, ...{ count: [...count, cycleIterator.next().value] } }
    return proposal
}
function tick() {
    return stage()
}
function commit() {
    state = { ...proposal }
    proposal = { ...state }
    return state
}
function abort() {
    proposal = { ...state }
    return state
}

module.exports = {
    stage,
    commit,
    abort,
    tick,
}
