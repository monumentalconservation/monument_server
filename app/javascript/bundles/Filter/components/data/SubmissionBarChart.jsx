import React from 'react';
import { VictoryBar, VictoryChart, VictoryAxis, VictoryGroup, VictoryLegend } from 'victory';


export default class SubmissionBarChart extends React.Component {
  constructor(props) {
    super(props);
  }
  
  render() {
    const {data} = this.props
    const {legend} = this.props

    return (
      <div>
        <VictoryChart
          className="mv0"
          domainPadding={10}
        >
        {/* <VictoryLegend x={50} y={10}
          orientation="horizontal"
          gutter={20}
          colorScale={[ "#E7ECEF", "#379392"]}
          style={{ fontSize: 12 }}
          data={[
            { name: legend, labels: {fill: "#E7ECEF"}} 
            //  { name: "Participants", labels: {fill: "#E7ECEF"} }
          ]}
        /> */}

          <VictoryAxis 
            style={{tickLabels: {fill: "#E7ECEF", fontSize: 8}}} fixLabelOverlap={true} />
          <VictoryGroup offset={10} style={{ data: { width: 6 } }} colorScale={["#E7ECEF", "#379392"]} >
            <VictoryBar
              data={data}
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