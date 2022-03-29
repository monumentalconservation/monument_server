import React, { useState } from 'react';
import MultiSelect from "react-multi-select-component";
import ZipForm from './ZipForm.jsx'

export default class Form extends React.Component {
  constructor(props) {
    super(props);
    
    this.state = {
      site: '',
      type: '',
      selected: [],
      start: '',
      end: ''
    }
  }

  handleSubmit = event => {
    event.preventDefault()
    // this returns a string of just the labels for selected tags
    const selectedTags = this.state.selected.map(obj => { return obj.label})
    this.props.refineView({site: this.state.site, 
                           type: this.state.type,
                           tags: selectedTags,
                           start: this.state.start,
                           end: this.state.end})
  }

  handleInputChange = event => {
    const target = event.target
    const value = target.type === 'checkbox' ? target.checked : target.value;
    const name = target.id;

    this.setState({
      [name]: value
    });
  }

  setSelectedTag = event => {
    const tag = event
    this.setState({selected: tag})
  }
  
  render() {
    const {selected} = this.state
    const options = this.props.tags.map(tag => { return {label: tag, value: tag}})
    const selectString = {
                            selectSomeItems: "Select tags",
                          }
    const zipButton = <ZipForm email={this.props.email} site={this.state.site} tags={this.state.selected} type={this.state.type}/>
    const defaultSelect = (this.props.siteName && this.props.siteName) || "Select Site"

    return (
      <form className="ph4 pv4 mb0 br1" onSubmit={this.handleSubmit}>
          <div className="flex flex-wrap items-center justify-between">
            <span className="h-25 w-100">
              <select id="site" className="dark-color w-100" onChange={this.handleInputChange}>
                <option defaultValue="">{defaultSelect}</option>
              {this.props.siteNames.sort().map((site, i) => 
                <option 
                  value={site} 
                  key={i}
                  className="dark-color w-100">{site}</option>)}
              </select>
            </span>

            <span className="h-25 w-100">
              <MultiSelect
                options={options}
                value={selected}
                onChange={this.setSelectedTag}
                labelledBy={"Select"}
                overrideStrings={selectString}
                />
            </span>

            {/* styling for input are in form.scss */}
            <span className="h-25 w-100 mt4">
              <label for="start" class="normal">Start date:</label>
              <input type="date" id="start" onChange={this.handleInputChange}></input>
            </span>

            <span className="h-25 w-100">
              <label for="end"  class="normal">End date:</label>
              <input type="date" id="end" onChange={this.handleInputChange}></input>
            </span>

            <span className="h-25 w-100 flex justify-around">
              <button className="mt4 white-background dark-color" type="submit" onClick={this.handleSubmit}>
                Search
              </button>

              <button className="mt4 white-background dark-color" type="submit" onClick={() => window.location.replace('/')}>
                Clear
              </button>
            </span>
          </div>
          
          {this.props.email ? zipButton : null}

        </form>
    )
  }
}