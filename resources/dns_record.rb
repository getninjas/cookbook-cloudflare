actions :create, :delete
default_action :create

attribute :name, :name_attribute => true, :kind_of => String, :required => true
attribute :record_name, :kind_of => [String, FalseClass], :default => false
attribute :zone, :kind_of => String, :required => true
attribute :content, :kind_of => [String, FalseClass], :default => false
attribute :type, :kind_of => String, :equal_to => ['A', 'CNAME'], :default => 'A'
attribute :ttl, :kind_of => Fixnum, :default => 1

def exists?
    cf_record = get_same_name_record or return false
    cf_record['zone_name'] == zone && cf_record['display_name'] == record_name && cf_record['content'] == content && cf_record['type'] == type && cf_record['ttl'] == ttl.to_s
end

def name_exists?
    !!get_same_name_record
end

def create
    node.cloudflare_client.rec_new zone, type, record_name, content, ttl
end

def delete
    node.cloudflare_client.rec_delete_by_name zone, record_name
end

alias_method :old_record_name, :record_name
def record_name *args
    # we default to the resource name if no explicit record_name was given
    @record_name = name if !@record_name
    old_record_name *args
end

alias_method :old_content, :content
def content *args
    # we default to the node's ipaddress if no content was explicitely given
    @content = node.ipaddress if !@content
    old_content *args
end

private

def get_same_name_record
    Chef::Application.fatal!("Unknown DNS zone #{zone}!") unless node.cloudflare_client.zone_exists? zone
    node.cloudflare_client.get_record zone, record_name
end
