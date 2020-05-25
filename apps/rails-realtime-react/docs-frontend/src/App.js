
import ActionCable from 'actioncable'

import React, { Component } from 'react'
import './App.css'

class App extends Component {
  state = { text: '' }

  componentDidMount() {
    window.fetch('http://localhost:3001/notes/1').then(data => {
      data.json().then(res => {
        this.setState({ text: res.text })
      })
    })
    const cable = ActionCable.createConsumer('ws://localhost:3001/cable')
    this.sub = cable.subscriptions.create('NotesChannel', {
      received: this.handleReceiveNewText
    })
  }
  
  handleChange = e => {
    this.setState({ text: e.target.value })
    this.sub.send({ text: e.target.value, id: 1 })
  }

  handleReceiveNewText = ({ text }) => {
    if (text !== this.state.text) {
      this.setState({ text })
    }
  }

  render() {
    return (
        <div>
      <h1>Benvenuti al Google Doc dei poveri..</h1>      
        <textarea
        value={this.state.text}
        onChange={this.handleChange}
      />
      <p>Fatto con Node (FE) e RoR (BE) e usando Channel API per parlarsi..</p>
      </div>
    )
  }
}

export default App