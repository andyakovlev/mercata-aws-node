# 🏴‍☠️ Node Provisioning

### So you want to mine silva, Marooch?

1. Join our [**Discord**](https://discord.gg/QTWxdZaM), navigate to the [validator channel](https://discord.com/channels/1074825209175093349/1241065063452770434) and introduce yourself.
    1. You will need to provide your future node’s domain name and have access to managing the DNS settings for that name.
    2. You will get two sets of credentials - `CLIENT_ID` and `CLIENT_SECRET`.
2. Create an [**AWS**](https://aws.amazon.com/) account to receive credits or use your existing environment.
3. Make sure you are in us-east-1 (select in upper right corner)
4. Download [EC2 Strato Node Template File](https://github.com/andyakovlev/mercata-aws-node/blob/main/mercata-ec2-instance.yml) `mercata-ec2-instance.yml` from GitHub.
5. **In AWS Set up your EC2.** Go to **CloudFormation** and click **[ Create stack ]**.
    1. Use `mercata-ec2-instance.yml` template from step 3.
6. Update your DNS A record with the EC2 instances public IP
7. **Connect to the instance to finish installation.** Go to **EC2** > Instances.
    1. Click on the Instance ID of the new node and connect to the instance.
8. **Install the node.**
    1. **Check prerequisites are ready.** In the terminal enter command `sudo systemctl is-active docker` , if it returns `active` the **CloudFormation** script has worked and has set up the prerequisites to deploy your node! 
    2. **Install STRATO.** Type `sudo bash /tmp/mercata-aws-node/strato_setup_script.sh` . Enter your node’s `domain name`, as well as `CLIENT_ID` and `CLIENT_SECRET` you got from us.
    3. **Install SLL**. Run `sudo python3 /tmp/mercata-aws-node/ssl_setup.py` and enter your `email` and node’s `domain name`.
    4. **Launch STRATO.** Run `sudo ./strato-run.sh` then launch provided link in browser after the install to verify you are up and running. 
9. Return to Discord and inform us that your node is running. The elders will vote you in, connecting your node to the mainnet. This will make you eligible for all the benefits and rewards of our [**Validator Program**](https://www.notion.so/STRATO-Validator-Program-21c573d0b294448bb5fd42d4d6e3a3cb?pvs=21).

## Notes

- Run `sudo bash /tmp/mercata-aws-node/update.sh` to clone latest git version of this

- To access strato node `cd /datadrive/strato-getting-started/` `sudo ./strato --help`

- To troubleshoot deployment run `sudo docker ps`