import React from 'react';

import SubmissionBarChart from './data/SubmissionBarChart'
import SiteBarChart from './data/SiteBarChart'
import TagPieChart from './data/TagPieChart'

export default class DataVis extends React.Component {
  constructor(props){
    super(props)
  }
  

  render() {

    const {submissionsData} = this.props
    const monthlyData = submissionsData != "undefined" ? submissionsData.byMonth : []
    const tagDataMost = submissionsData != 'undefined' ? submissionsData.tagsMost : []
    const tagDataLeast = submissionsData != 'undefined' ? submissionsData.tagsLeast : []
    const siteData = submissionsData != 'undefined' ? submissionsData.siteCounts : []
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
          </div>
        </div>


        {/*   Site Specific stats */}
        <div className="pa4 mt4 br2 data-box">
          <h2 className="mb4 f1 title mb2">Submission numbers for {this.props.siteName ? this.props.siteName : "all sites"} over the last year</h2>
        
          <SubmissionBarChart submissionData={monthlyData} color={"#E7ECEF"} dataName={"Submissions"}/>
          <hr className="w-60 ml0 mt0"></hr>

          <h2 className="mb4 f1 title mb2">Submissions per site</h2>
          
          <SiteBarChart submissionData={siteData} color={"#E7ECEF"} dataName={"Submissions per site"}/>

{/* <TagPieChart data={siteData} /> */}
          <hr className="w-60 ml0 mt0"></hr>

          <h2 className="mb4 f1 title mb2">Most used tags</h2>
          
          <TagPieChart data={tagDataMost} />

          <hr className="w-60 ml0 mt0"></hr>

          <h2 className="mb4 f1 title mb2">Least used tags</h2>
          
          <TagPieChart data={tagDataLeast} />
          
        </div>




      </div>
    )
  }
}