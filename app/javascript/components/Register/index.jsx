import React from 'react';
import MainContainer from '../MainContainer';
import HandleForm from '../HandleForm';
import messageBus from '../../utils/messageBus'
import {createUserProfile} from '../API';
import PropTypes from 'prop-types';
import {Link} from 'react-router-dom';

const Register = ({fetchProfile, history}) => {
  const onFormSubmit = (formData) => {

    return createUserProfile(formData).then(({ data: { id }}) => {
      localStorage.setItem('player', JSON.stringify({id: id}));
      messageBus.info('profile successfully created');
      fetchProfile();
      history.push('/profile')
    }).catch((res) => {
      const messages = Object.keys(res.response.data.errors).map((key) => [key, res.response.data.errors[key]].join(': ')).join()
      messageBus.error(messages)
    })
  };

  return (
    <MainContainer dataTestId='register'>
      <h3>Please sign in or create a profile!</h3>
      <HandleForm onSubmit={onFormSubmit} step="handle" />
      <Link className="btn" to="/sign_in">sign in with an existing account</Link>
    </MainContainer>
  )
};

Register.propTypes = {
  fetchProfile: PropTypes.func,
  history: PropTypes.object,
};

export default Register;
