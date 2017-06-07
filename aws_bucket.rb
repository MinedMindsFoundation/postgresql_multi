require 'aws-sdk'

Aws.use_bundled_cert!  # resolves "certificate verify failed"

load "./local_env.rb" if File.exists?("./local_env.rb")

# Method to connect to AWS S3 bucket
def connect_to_s3()
  Aws::S3::Client.new(
    access_key_id: ENV['S3_KEY'],
    secret_access_key: ENV['S3_SECRET'],
    region: ENV['AWS_REGION'],
    force_path_style: ENV['PATH_STYLE']
  )
end

# Method to list AWS S3 buckets
def list_s3_buckets()
  s3 = connect_to_s3()
  response = s3.list_buckets
  response.buckets.each do |bucket|
    puts "#{bucket.creation_date} #{bucket.name}"
  end
end

# list_s3_buckets()

# Method to upload file to AWS S3 bucket if not already present
def save_file_to_s3_bucket(bucket, file)
  connect_to_s3()
  s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
  obj = s3.bucket(bucket).object(file)
  if obj.exists?
    puts "File #{file} already exists in the bucket."
  else
    obj.upload_file(file)
    puts "Uploaded file (#{file}) to bucket (#{bucket})."
  end
end

# save_file_to_s3_bucket("image-prototype", "nemo.png")

# Method to list files in AWS S3 bucket
def list_s3_bucket_files(bucket)
  s3 = connect_to_s3()
  resp = s3.list_objects_v2(bucket: bucket)
  counter = 1
  resp.contents.each do |obj|
    puts "#{bucket} bucket file #{counter}: #{obj.key}"
    counter += 1
  end
end

# list_s3_bucket_files("image-prototype")

# Method to generate secure URL for target file (expires after 15 minutes)
def generate_url(bucket, file)
  connect_to_s3()
  signer = Aws::S3::Presigner.new
  url = signer.presigned_url(:get_object, bucket: bucket, key: file)
end

# generate_url("image-prototype", "nemo.png")