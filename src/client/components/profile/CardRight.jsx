// @flow

import React, { Component } from 'react';
import { Card, CardBlock } from 'reactstrap';

export default class CardRight extends Component {
  render() {
    return (
      <Card>
        <CardBlock height="98px">
          <center><h5>Trending</h5></center>
        </CardBlock>
      </Card>
    );
  }
}

