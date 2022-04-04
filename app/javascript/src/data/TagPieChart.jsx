import React from 'react';
import { VictoryPie, VictoryTooltip, VictoryLabel, VictoryTheme } from 'victory';

class CustomLabel extends React.Component {
  render() {
    return (
      <g>
        <VictoryLabel {...this.props}/>
        <VictoryTooltip
          {...this.props}
          x={200} y={250}
          orientation="top"
          pointerLength={0}
          cornerRadius={50}
          flyoutWidth={100}
          flyoutHeight={100}
          flyoutStyle={{ fill: "black" }}
        />
      </g>
    );
  }
}

CustomLabel.defaultEvents = VictoryTooltip.defaultEvents;


export default class TagPieChart extends React.Component {
  render() {
    return (
        <VictoryPie
          style={{ labels: { fill: "white" } }}
          innerRadius={100}
          labelRadius={120}
          labels={({ datum }) => `${datum.y}: ${datum.x}`}
          labelComponent={<CustomLabel />}
          data={this.props.data}
        />
    );
  }
}