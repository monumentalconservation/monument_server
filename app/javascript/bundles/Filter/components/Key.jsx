import React from 'react';

export default class Key extends React.Component {
  constructor(props) {
    super(props);
  }
  
  render() {
    return (
      <div className="flex flex-wrap justify-around items-center mt3 mb6">
        <div className="pv3 tc w-100">Key</div>
        <div className="pv4 tc w-25 whatsapp">WhatsApp</div>
        <div className="pv4 tc w-25 twitter">Twitter</div>
        <div className="pv4 tc w-25 instagram">Instagram</div>
        <div className="pv4 tc w-25 email">Email</div>
      </div>
    )
  }
}