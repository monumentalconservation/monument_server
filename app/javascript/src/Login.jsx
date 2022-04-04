import React from 'react';

class Login extends React.Component {
  constructor(props) {
    super(props);
  }

  NotLoggedIn = () => {
    return (
      <div className="w-100 flex-ns flex-wrap">
        Not logged in | <a className="ph1" href="/users/sign_in">Sign in</a>  |  <a className="ph1" href="/users/sign_up">Sign up</a>
      </div>
    )
  }
  
  LoggedIn = () => {
    return (
      <div className="w-100">
        <div className="pt1 tc w-100">
          {this.props.userEmail} | <a href='/admin' >Admin Interface</a>
        </div> 
      </div>
    )
  }

  render() {
    // if props empty string, they are not logged in
		const isNotLoggedIn = this.props.userEmail == "";
    return (
      <div className='w-30 absolute-ns top-0-ns right-1 z-3'>
        <div className="dn-m flex-ns flex-wrap justify-around items-center mt0 mb0  w-100">
          {isNotLoggedIn ? <this.NotLoggedIn/> : <this.LoggedIn /> }
        </div>
      </div>
    );
  }
}

export default Login