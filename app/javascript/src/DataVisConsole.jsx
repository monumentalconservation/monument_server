import React from 'react';

import SubmissionBarChart from './data/SubmissionBarChart'
// import SubmissionAreaChart from './data/SubmissionAreaChart'
import TypePieChart from './data/TypePieChart'

export default class DataVis extends React.Component {
  constructor(props){
    super(props)
  }
  

  render() {

    const {submissionsData} = this.props
    const monthlyData = submissionsData != "undefined" ? submissionsData.byMonth : []
    const tagData = submissionsData != 'undefined' ? submissionsData.aiTags : []
    const maxData = submissionsData != 'undefined' ? submissionsData.maxSubs : []
    const minData = submissionsData != 'undefined' ? submissionsData.minSubs : []

    
    return (
      <div>
        {/* project wide states */}
        <div className="pa4 mt4 br2 data-box">
          <h2 className="mb4 f1 title ">Project wide stats</h2>
          <div className="flex-ns items-end">
            <div className="w-30">
              <h1 className="data-bold-color mb0">{this.props.allSubmissionsTotal}</h1> 
              <p>Submissions</p>
              <hr className="w-60 ml0"></hr>
              Total
            </div>
            
            <div>
              {maxData.map((site)=>(<h3 className="f2 mb3 data-bold-color">{site}</h3>))}
              <hr className="w-60 ml0"></hr>
              Most popular
            </div>  

            <div>
              {minData.map((site)=>(<h3 className="f2 mb3 data-bold-color">{site}</h3>))}
              <hr className="w-60 ml0"></hr>
              Least popular
            </div>
            
            <div className="w-80 w-40-ns">
              {/* <TypePieChart data={typeData} /> */}
              <hr className="w-60 ml0"></hr>
              Type breakdown
            </div>
          </div>
          {/* Eventually there will be a snazzy area chart... if I can be bothered... */}
          {/* <SubmissionAreaChart data={monthlyData} /> */}
        </div>


        {/*   Site Specific stats */}
        <div className="pa4 mt4 br2 data-box">
          <h2 className="mb4 f1 title mb2">Submission numbers for {this.props.siteName ? this.props.siteName : "all sites"} over the last year</h2>
        
          <SubmissionBarChart submissionData={monthlyData} color={"#E7ECEF"} dataName={"Submissions"}/>
          <hr className="w-60 ml0 mt0"></hr>

          <h2 className="mb4 f1 title mb2">Tag numbers for all sites</h2>
          
          <SubmissionBarChart submissionData={tagData} color={"#379392"} dataName={"Tags"}/>
          <hr className="w-60 ml0 mt0"></hr>

          
        </div>




      </div>
    )
  }
}