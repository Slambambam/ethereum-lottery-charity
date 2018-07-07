import React, { Component } from 'react';
import { Button, Form, Message, Input } from 'semantic-ui-react';
import Campaign from '../../../ethereum/campaign';
import web3 from '../../../ethereum/web3';
import Layout from '../../../components/Layout';
import { Link, Router } from '../../../routes';

const initialState = {
  value: '',
  description: '',
  recipient: '',
  errorMessage: '',
  isLoading: false
}

class RequestNew extends Component {
  state = initialState;

  static async getInitialProps(props) {
    const { address } = props.query;
    return { address };
  }

  onSubmit = async (event) => {
    event.preventDefault();

    this.setState({ isLoading: true, errorMessage: '' });

    const campaign = Campaign(this.props.address);
    const { description, value, recipient } = this.state;

    try {
      const accounts = await web3.eth.getAccounts();

      await campaign.methods.createRequest(
        description,
        web3.utils.toWei(value, 'ether'),
        recipient
      ).send({
        from: accounts[0]
      });

      Router.replaceRoute(`/campaigns/${this.props.address}/requests`);
    } catch (err) {
      this.setState({ errorMessage: err.message });
    }

    this.setState(initialState);
  };

  render() {
    return (
      <Layout>
        <Link route={`/campaigns/${this.props.address}/requests`}>
          <a>
            Back
                    </a>
        </Link>
        <h3>Create a Request</h3>

        <Form onSubmit={this.onSubmit} error={!!this.state.errorMessage}>
          <Form.Field>
            <label>Description</label>
            <Input
              value={this.state.description}
              onChange={event => this.setState({ description: event.target.value })}
            />
          </Form.Field>
          <Form.Field>
            <label>Value in Ether</label>
            <Input
              label="ether"
              labelPosition="right"
              value={this.state.value}
              onChange={event => this.setState({ value: event.target.value })}
            />
          </Form.Field>
          <Form.Field>
            <label>Recipient</label>
            <Input
              value={this.state.recipient}
              onChange={event => this.setState({ recipient: event.target.value })}
            />
          </Form.Field>

          <Message
            error
            header="Error!"
            content={this.state.errorMessage}
          />

          <Button loading={this.state.isLoading} primary>Create!</Button>
        </Form>
      </Layout>
    );
  }
}

export default RequestNew;