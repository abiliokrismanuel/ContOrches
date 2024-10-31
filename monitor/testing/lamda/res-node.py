import boto3
import logging

# Setup logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # Inisialisasi client EC2
    ec2 = boto3.client('ec2', region_name='us-east-1')  # Ganti dengan region yang sesuai

    # Daftar EC2 instance IDs yang ingin di-restart
    instance_ids = ['<id_ec2>', '<id_ec2>']  # Ganti dengan instance IDs yang sesuai

    try:
        logger.info(f'Restarting EC2 instances: {instance_ids} in region us-east-1')

        # Me-restart beberapa instance EC2
        response = ec2.reboot_instances(InstanceIds=instance_ids)  # Masukkan list of strings langsung

        logger.info(f'Successful response: {response}')

        return {
            'statusCode': 200,
            'body': f'Successfully restarted EC2 instances: {instance_ids}'
        }

    except Exception as e:
        logger.error(f'Error restarting EC2 instances: {str(e)}')
        return {
            'statusCode': 500,
            'body': f'Error restarting EC2 instances: {str(e)}'
        }
