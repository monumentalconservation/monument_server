import React from 'react';
import { VictoryPie, VictoryTooltip, VictoryLabel, VictoryTheme } from 'victory';

// export default class TypePieChart extends React.Component {
//   constructor(props) {
//     super(props);
//   }
  
//   render() {
//     return (
//       <VictoryPie
//         data={this.props.data}
//         labelRadius={140}
//         radius={200}
//         innerRadius={130}
//         style={{ labels: { fill: "white", fontSize: 12, fontWeight: "" } }}
//         labels={({ datum }) => `${datum.y}: ${datum.x}`}
//         labelComponent={
//           <VictoryTooltip 
//             style={{ fill: "grey", fontSize: 34  }} 
//             dy={0} 
//             centerOffset={{ cx: 5 }}
//             constrainToVisibleArea
//             pointerLength={0}
//             flyoutWidth={250}
//             flyoutHeight={100}/>
//         }
//       />
//     )
//   }
// }

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