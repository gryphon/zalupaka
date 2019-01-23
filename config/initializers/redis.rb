REDIS_CONFIG = { 
  host: 'redis',
  port: 6379,
  db: 14,
  password: nil
}

Zalupaka::Application.config.session_store :redis_store, servers: REDIS_CONFIG.merge(db: 14, namespace: 'zlp_session')
Zalupaka::Application.config.cache_store = :redis_store, REDIS_CONFIG.merge(db: 14, namespace: 'zlp_cache', expires_in: 90.minutes)
