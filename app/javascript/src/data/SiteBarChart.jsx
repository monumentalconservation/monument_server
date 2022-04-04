import React from 'react';
import { VictoryBar, VictoryChart, VictoryAxis, VictoryGroup, VictoryLegend } from 'victory';


export default class SubmissionBarChart extends React.Component {
  constructor(props) {
    super(props);
  }
  
  render() {
    const {submissionData} = this.props
    const {participantData} = this.props
    const {color} = this.props
    const {dataName} = this.props
    return (
      <div className="plf">
        <VictoryChart
          className="mv0"
          domainPadding={1}
          height={600}
          width={600}
          padding={{ top: 10, right: 50, bottom: 10, left: 120}}
        >
          <VictoryAxis 
            style={{tickLabels: {fill: "#E7ECEF", fontSize: 8}}}
           />
          <VictoryGroup offset={10} style={{ data: { width: 10 } }} colorScale={[color]} >
            <VictoryBar horizontal
              data={submissionData}
              labels={({ datum }) => `${Math.floor(datum.y)}`}
              animate={{
                duration: 2000,
                // onLoad: { duration: 1000 }
              }}
              barRatio={0.8}
              alignment="middle"
              style={{
                labels: { fontSize: 8, fill: "#E7ECEF"}
              }}
            />

           
          </VictoryGroup>
        </VictoryChart>
      </div>
    )
  }
}