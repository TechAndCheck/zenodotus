# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: false
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/puma/all/puma.rbi
#
# puma-5.2.2

class Puma::HttpParser
  def body; end
  def error?; end
  def execute(arg0, arg1, arg2); end
  def finish; end
  def finished?; end
  def initialize; end
  def nread; end
  def reset; end
end
class Puma::MiniSSL::SSLContext
  def initialize(arg0); end
end
module Puma::MiniSSL
  def self.check; end
end
class Puma::MiniSSL::Engine
  def extract; end
  def init?; end
  def inject(arg0); end
  def peercert; end
  def read; end
  def self.client; end
  def self.server(arg0); end
  def shutdown; end
  def ssl_vers_st; end
  def write(arg0); end
end
module Puma
  def self.forkable?; end
  def self.jruby?; end
  def self.mri?; end
  def self.set_thread_name(name); end
  def self.ssl?; end
  def self.stats; end
  def self.stats_hash; end
  def self.stats_object=(val); end
  def self.windows?; end
end
module Puma::JSON
  def self.generate(value); end
  def self.serialize_object_key(output, value); end
  def self.serialize_string(output, value); end
  def self.serialize_value(output, value); end
end
class Puma::JSON::SerializationError < StandardError
end
class Puma::MiniSSL::Socket
  def <<(data); end
  def bad_tlsv1_3?; end
  def close; end
  def closed?; end
  def engine_read_all; end
  def flush; end
  def initialize(socket, engine); end
  def peeraddr; end
  def peercert; end
  def read_and_drop(timeout = nil); end
  def read_nonblock(size, *_); end
  def readpartial(size); end
  def should_drop_bytes?; end
  def ssl_version_state; end
  def syswrite(data); end
  def to_io; end
  def write(data); end
  def write_nonblock(data, *_); end
end
class Puma::MiniSSL::Context
  def ca; end
  def ca=(ca); end
  def cert; end
  def cert=(cert); end
  def check; end
  def initialize; end
  def key; end
  def key=(key); end
  def no_tlsv1; end
  def no_tlsv1=(tlsv1); end
  def no_tlsv1_1; end
  def no_tlsv1_1=(tlsv1_1); end
  def ssl_cipher_filter; end
  def ssl_cipher_filter=(arg0); end
  def verification_flags; end
  def verification_flags=(arg0); end
  def verify_mode; end
  def verify_mode=(arg0); end
end
class Puma::MiniSSL::Server
  def accept; end
  def accept_nonblock; end
  def addr; end
  def close; end
  def closed?; end
  def initialize(socket, ctx); end
  def to_io; end
end
module Puma::Rack
end
class Puma::Rack::Options
  def handler_opts(options); end
  def parse!(args); end
end
class Puma::Rack::Builder
  def call(env); end
  def generate_map(default_app, mapping); end
  def initialize(default_app = nil, &block); end
  def map(path, &block); end
  def run(app); end
  def self.app(default_app = nil, &block); end
  def self.new_from_string(builder_script, file = nil); end
  def self.parse_file(config, opts = nil); end
  def to_app; end
  def use(middleware, *args, &block); end
  def warmup(prc = nil, &block); end
end
class Puma::UnknownPlugin < RuntimeError
end
class Puma::PluginLoader
  def create(name); end
  def fire_starts(launcher); end
  def initialize; end
end
class Puma::PluginRegistry
  def add_background(blk); end
  def find(name); end
  def fire_background; end
  def initialize; end
  def register(name, cls); end
end
class Puma::Plugin
  def in_background(&blk); end
  def self.create(&blk); end
  def self.extract_name(ary); end
end
class Puma::UnsupportedOption < RuntimeError
end
module Puma::Const
end
class Puma::DSL
  def _load_from(path); end
  def _offer_plugins; end
  def activate_control_app(url = nil, opts = nil); end
  def after_worker_boot(&block); end
  def after_worker_fork(&block); end
  def app(obj = nil, &block); end
  def before_fork(&block); end
  def bind(url); end
  def bind_to_activated_sockets(bind = nil); end
  def clean_thread_locals(which = nil); end
  def clear_binds!; end
  def debug; end
  def default_host; end
  def directory(dir); end
  def drain_on_shutdown(which = nil); end
  def early_hints(answer = nil); end
  def environment(environment); end
  def extra_runtime_dependencies(answer = nil); end
  def first_data_timeout(seconds); end
  def force_shutdown_after(val = nil); end
  def fork_worker(after_requests = nil); end
  def get(key, default = nil); end
  def initialize(options, config); end
  def inject(&blk); end
  def io_selector_backend(backend); end
  def load(file); end
  def log_formatter(&block); end
  def log_requests(which = nil); end
  def lowlevel_error_handler(obj = nil, &block); end
  def max_fast_inline(num_of_requests); end
  def mutate_stdout_and_stderr_to_sync_on_write(enabled = nil); end
  def nakayoshi_fork(enabled = nil); end
  def on_refork(&block); end
  def on_restart(&block); end
  def on_worker_boot(&block); end
  def on_worker_fork(&block); end
  def on_worker_shutdown(&block); end
  def out_of_band(&block); end
  def persistent_timeout(seconds); end
  def pidfile(path); end
  def plugin(name); end
  def port(port, host = nil); end
  def preload_app!(answer = nil); end
  def prune_bundler(answer = nil); end
  def queue_requests(answer = nil); end
  def quiet(which = nil); end
  def rackup(path); end
  def raise_exception_on_sigterm(answer = nil); end
  def restart_command(cmd); end
  def self.ssl_bind_str(host, port, opts); end
  def set_default_host(host); end
  def set_remote_address(val = nil); end
  def shutdown_debug(val = nil); end
  def ssl_bind(host, port, opts); end
  def state_path(path); end
  def state_permission(permission); end
  def stdout_redirect(stdout = nil, stderr = nil, append = nil); end
  def tag(string); end
  def threads(min, max); end
  def wait_for_less_busy_worker(val = nil); end
  def worker_boot_timeout(timeout); end
  def worker_shutdown_timeout(timeout); end
  def worker_timeout(timeout); end
  def workers(count); end
  include Puma::ConfigDefault
end
module Puma::ConfigDefault
end
class Puma::UserFileDefaultOptions
  def [](key); end
  def []=(key, value); end
  def all_of(key); end
  def default_options; end
  def fetch(key, default_value = nil); end
  def file_options; end
  def final_options; end
  def finalize_values; end
  def initialize(user_options, default_options); end
  def user_options; end
end
class Puma::Configuration
  def app; end
  def app_configured?; end
  def clamp; end
  def config_files; end
  def configure; end
  def default_max_threads; end
  def environment; end
  def environment_str; end
  def final_options; end
  def flatten!; end
  def flatten; end
  def infer_tag; end
  def initialize(user_options = nil, default_options = nil, &block); end
  def initialize_copy(other); end
  def load; end
  def load_plugin(name); end
  def load_rackup; end
  def options; end
  def plugins; end
  def puma_default_options; end
  def rack_builder; end
  def rackup; end
  def run_hooks(key, arg, events); end
  def self.random_token; end
  def self.temp_path; end
  include Puma::ConfigDefault
end
class Puma::Configuration::ConfigMiddleware
  def call(env); end
  def initialize(config, app); end
end
class Puma::NullIO
  def close; end
  def each; end
  def eof?; end
  def flush; end
  def gets; end
  def puts(*ary); end
  def read(count = nil, _buffer = nil); end
  def rewind; end
  def size; end
  def string; end
  def sync; end
  def sync=(v); end
  def write(*ary); end
end
class Puma::ErrorLogger
  def debug(options = nil); end
  def info(options = nil); end
  def initialize(ioerr); end
  def ioerr; end
  def log(str); end
  def request_dump(req); end
  def request_headers(req); end
  def request_parsed?(req); end
  def request_title(req); end
  def self.stdio; end
  def title(options = nil); end
  include Puma::Const
end
class Puma::Events
  def connection_error(error, req, text = nil); end
  def debug(str); end
  def debug_error(error, req = nil, text = nil); end
  def error(str); end
  def fire(hook, *args); end
  def fire_on_booted!; end
  def fire_on_restart!; end
  def fire_on_stopped!; end
  def format(str); end
  def formatter; end
  def formatter=(arg0); end
  def initialize(stdout, stderr); end
  def log(str); end
  def on_booted(&block); end
  def on_restart(&block); end
  def on_stopped(&block); end
  def parse_error(error, req); end
  def register(hook, obj = nil, &blk); end
  def self.null; end
  def self.stdio; end
  def self.strings; end
  def ssl_error(error, ssl_socket); end
  def stderr; end
  def stdout; end
  def unknown_error(error, req = nil, text = nil); end
  def write(str); end
end
class Puma::Events::DefaultFormatter
  def call(str); end
end
class Puma::Events::PidFormatter
  def call(str); end
end
class Puma::ThreadPool
  def <<(work); end
  def auto_reap!(timeout = nil); end
  def auto_trim!(timeout = nil); end
  def backlog; end
  def busy_threads; end
  def clean_thread_locals; end
  def clean_thread_locals=(arg0); end
  def initialize(min, max, *extra, &block); end
  def out_of_band_hook; end
  def out_of_band_hook=(arg0); end
  def pool_capacity; end
  def reap; end
  def self.clean_thread_locals; end
  def shutdown(timeout = nil); end
  def spawn_thread; end
  def spawned; end
  def trigger_out_of_band_hook; end
  def trim(force = nil); end
  def trim_requested; end
  def wait_for_less_busy_worker(delay_s); end
  def wait_until_not_full; end
  def waiting; end
  def with_force_shutdown; end
  def with_mutex(&block); end
end
class Puma::ThreadPool::ForceShutdown < RuntimeError
end
class Puma::ThreadPool::Automaton
  def initialize(pool, timeout, thread_name, message); end
  def start!; end
  def stop; end
end
class Puma::UnsupportedBackend < StandardError
end
class Puma::Reactor
  def add(client); end
  def initialize(backend, &block); end
  def register(client); end
  def run(background = nil); end
  def select_loop; end
  def shutdown; end
  def wakeup!(client); end
end
class IO
end
module IO::WaitReadable
end
class Puma::ConnectionError < RuntimeError
end
class Puma::Client
  def body; end
  def call; end
  def can_close?; end
  def close; end
  def closed?(*args, &block); end
  def decode_chunk(chunk); end
  def eagerly_finish; end
  def env; end
  def finish(timeout); end
  def hijacked; end
  def in_data_phase; end
  def initialize(io, env = nil); end
  def inspect; end
  def io; end
  def io_ok?; end
  def peerip; end
  def peerip=(arg0); end
  def read_body; end
  def read_chunked_body; end
  def ready; end
  def remote_addr_header; end
  def remote_addr_header=(arg0); end
  def reset(fast_check = nil); end
  def set_ready; end
  def set_timeout(val); end
  def setup_body; end
  def setup_chunked_body(body); end
  def tempfile; end
  def timeout!; end
  def timeout; end
  def timeout_at; end
  def to_io; end
  def try_to_finish; end
  def write_chunk(str); end
  def write_error(status_code); end
  extend Forwardable
  include Puma::Const
end
module Puma::Util
  def nakayoshi_gc(events); end
  def parse_query(qs, d = nil, &unescaper); end
  def pipe; end
  def self.nakayoshi_gc(events); end
  def self.parse_query(qs, d = nil, &unescaper); end
  def self.pipe; end
  def self.unescape(s, encoding = nil); end
  def unescape(s, encoding = nil); end
end
class Puma::Util::HeaderHash < Hash
  def [](k); end
  def []=(k, v); end
  def delete(k); end
  def each; end
  def has_key?(k); end
  def include?(k); end
  def initialize(hash = nil); end
  def key?(k); end
  def member?(k); end
  def merge!(other); end
  def merge(other); end
  def replace(other); end
  def self.new(hash = nil); end
  def to_hash; end
end
class Puma::MiniSSL::ContextBuilder
  def context; end
  def events; end
  def initialize(params, events); end
  def params; end
end
class Puma::Binder
  def activated_sockets; end
  def add_ssl_listener(host, port, ctx, optimize_for_latency = nil, backlog = nil); end
  def add_tcp_listener(host, port, optimize_for_latency = nil, backlog = nil); end
  def add_unix_listener(path, umask = nil, mode = nil, backlog = nil); end
  def close; end
  def close_listeners; end
  def connected_ports; end
  def create_activated_fds(env_hash); end
  def create_inherited_fds(env_hash); end
  def env(sock); end
  def envs; end
  def inherit_ssl_listener(fd, ctx); end
  def inherit_tcp_listener(host, port, fd); end
  def inherit_unix_listener(path, fd); end
  def inherited_fds; end
  def initialize(events, conf = nil); end
  def ios; end
  def ios=(arg0); end
  def listeners; end
  def listeners=(arg0); end
  def loc_addr_str(io); end
  def loopback_addresses; end
  def parse(binds, logger, log_msg = nil); end
  def proto_env; end
  def redirects_for_restart; end
  def redirects_for_restart_env; end
  def socket_activation_fd(int); end
  def synthesize_binds_from_activated_fs(binds, only_matching); end
  def unix_paths; end
  include Puma::Const
end
class Puma::IOBuffer < String
  def append(*args); end
  def reset; end
end
module Puma::Request
  def default_server_port(env); end
  def fast_write(io, str); end
  def fetch_status_code(status); end
  def handle_request(client, lines); end
  def illegal_header_key?(header_key); end
  def illegal_header_value?(header_value); end
  def normalize_env(env, client); end
  def req_env_post_parse(env); end
  def str_early_hints(headers); end
  def str_headers(env, status, headers, res_info, lines); end
  include Puma::Const
end
class Puma::Server
  def add_ssl_listener(*args, &block); end
  def add_tcp_listener(*args, &block); end
  def add_unix_listener(*args, &block); end
  def app; end
  def app=(arg0); end
  def auto_trim_time; end
  def auto_trim_time=(arg0); end
  def backlog; end
  def begin_restart(sync = nil); end
  def binder; end
  def binder=(arg0); end
  def client_error(e, client); end
  def closed_socket?(socket); end
  def connected_ports(*args, &block); end
  def cork_socket(socket); end
  def early_hints; end
  def early_hints=(arg0); end
  def events; end
  def first_data_timeout; end
  def first_data_timeout=(arg0); end
  def graceful_shutdown; end
  def halt(sync = nil); end
  def handle_check; end
  def handle_servers; end
  def inherit_binder(bind); end
  def initialize(app, events = nil, options = nil); end
  def leak_stack_on_error; end
  def leak_stack_on_error=(arg0); end
  def lowlevel_error(e, env, status = nil); end
  def max_threads; end
  def max_threads=(arg0); end
  def min_threads; end
  def min_threads=(arg0); end
  def notify_safely(message); end
  def persistent_timeout; end
  def persistent_timeout=(arg0); end
  def pool_capacity; end
  def process_client(client, buffer); end
  def reactor_wakeup(client); end
  def reaping_time; end
  def reaping_time=(arg0); end
  def requests_count; end
  def run(background = nil, thread_name: nil); end
  def running; end
  def self.closed_socket_supported?; end
  def self.current; end
  def self.tcp_cork_supported?; end
  def shutting_down?; end
  def stats; end
  def stop(sync = nil); end
  def thread; end
  def uncork_socket(socket); end
  def with_force_shutdown(client, &block); end
  extend Forwardable
  include Puma::Const
  include Puma::Request
end
class Puma::Runner
  def app; end
  def close_control_listeners; end
  def debug(str); end
  def development?; end
  def error(str); end
  def initialize(cli, events); end
  def load_and_bind; end
  def log(str); end
  def output_header(mode); end
  def redirect_io; end
  def redirected_io?; end
  def ruby_engine; end
  def start_control; end
  def start_server; end
  def stop_control; end
  def test?; end
end
class Puma::Cluster < Puma::Runner
  def all_workers_booted?; end
  def check_workers; end
  def cull_workers; end
  def fork_worker!; end
  def halt; end
  def initialize(cli, events); end
  def next_worker_index; end
  def phased_restart; end
  def preload?; end
  def redirect_io; end
  def reload_worker_directory; end
  def restart; end
  def run; end
  def setup_signals; end
  def spawn_worker(idx, master); end
  def spawn_workers; end
  def start_phased_restart; end
  def stats; end
  def stop; end
  def stop_blocked; end
  def stop_workers; end
  def timeout_workers; end
  def wait_workers; end
  def wakeup!; end
  def worker(index, master); end
end
class Puma::Cluster::WorkerHandle
  def boot!; end
  def booted?; end
  def hup; end
  def index; end
  def initialize(idx, pid, phase, options); end
  def kill; end
  def last_checkin; end
  def last_status; end
  def phase; end
  def phase=(arg0); end
  def pid; end
  def pid=(arg0); end
  def ping!(status); end
  def ping_timeout; end
  def signal; end
  def started_at; end
  def term; end
  def term?; end
end
class Puma::Cluster::Worker < Puma::Runner
  def index; end
  def initialize(index:, master:, launcher:, pipes:, server: nil); end
  def master; end
  def run; end
  def spawn_worker(idx); end
  def wakeup!; end
end
class Puma::Single < Puma::Runner
  def halt; end
  def restart; end
  def run; end
  def stats; end
  def stop; end
  def stop_blocked; end
end
class Puma::Launcher
  def binder; end
  def close_binder_listeners; end
  def clustered?; end
  def config; end
  def connected_ports; end
  def delete_pidfile; end
  def environment; end
  def events; end
  def extra_runtime_deps_directories; end
  def files_to_require_after_prune; end
  def generate_restart_data; end
  def graceful_stop; end
  def halt; end
  def initialize(conf, launcher_args = nil); end
  def integrate_with_systemd; end
  def log(str); end
  def log_config; end
  def options; end
  def phased_restart; end
  def prune_bundler; end
  def prune_bundler?; end
  def puma_wild_location; end
  def reload_worker_directory; end
  def require_paths_for_gem(gem_spec); end
  def require_rubygems_min_version!(min_version, feature); end
  def restart!; end
  def restart; end
  def restart_args; end
  def restart_dir; end
  def run; end
  def set_process_title; end
  def set_rack_environment; end
  def setup_signals; end
  def spec_for_gem(gem_name); end
  def stats; end
  def stop; end
  def thread_status; end
  def title; end
  def unsupported(str); end
  def with_unbundled_env; end
  def write_pid; end
  def write_state; end
end
