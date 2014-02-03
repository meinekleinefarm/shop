if Rails.env.staging? or Rails.env.production?
  current_sha = `git rev-parse HEAD`[0..8]
  Rails.application.middleware.insert_before Rack::Lock, RackStatsD::ProcessUtilization, 'mkf-shop', current_sha
end