import React, { Component } from 'react';
import { Button, Table } from 'semantic-ui-react';
import web3 from '../ethereum/web3';
import Campaign from '../ethereum/campaign';
import { Router } from '../routes';

const initialState = {
  errorMessage: '',
  isLoading: false
}

class RequestRow extends Component {
  state = initialState;

  onApprove = async (event) => {
    this.setState({ isLoading: true, errorMessage: '' });

    const campaign = Campaign(this.props.address);
    const accounts = await web3.eth.getAccounts();

    try {
      await campaign.methods.approveRequest(this.props.id).send({
        from: accounts[0]
      });

      Router.replaceRoute(`/campaigns/${this.props.address}/requests`);
    } catch (err) {
      this.setState({ errorMessage: err.message });
      console.log(this.state.errorMessage)
    }

    this.setState(initialState);
  };

  onFinalize = async (event) => {
    this.setState({ isLoading: true, errorMessage: '' });

    const campaign = Campaign(this.props.address);
    const accounts = await web3.eth.getAccounts();

    try {
      await campaign.methods.finalizeRequest(this.props.id).send({
        from: accounts[0]
      });

      Router.replaceRoute(`/campaigns/${this.props.address}/requests`);
    } catch (err) {
      this.setState({ errorMessage: err.message });
      console.log(this.state.errorMessage)
    }

    this.setState(initialState);
  };

  render() {
    const { Row, Cell } = Table;
    const { id, request, approversCount } = this.props;
    const readyToFinalize = request.approvalCount > (approversCount / 2);
    return (
      <Row disabled={request.complete} positive={readyToFinalize && !request.complete}>
        <Cell>{id}</Cell>
        <Cell>{request.description}</Cell>
        <Cell>{web3.utils.fromWei(request.value, 'ether')}</Cell>
        <Cell>{request.recipient}</Cell>
        <Cell>{request.approvalCount}/{approversCount}</Cell>
        <Cell>
          {request.complete ? null : (
            <Button loading={this.state.isLoading} color="green" basic onClick={this.onApprove}>Approve</Button>
          )}
        </Cell>
        <Cell>
          {request.complete ? null : (
            <Button loading={this.state.isLoading} color="teal" basic onClick={this.onFinalize}>Finalize</Button>
          )}
        </Cell>
      </Row>
    );
  }
}

export default RequestRow;