require 'ostruct'
require 'yaml'
gattica_config = YAML.load_file("#{Rails.root}/config/gattica.yml")
GatticaConfig = OpenStruct.new gattica_config[Rails.env]
GATTICA_INSTANCE = Gattica.new({
                                email:      GatticaConfig.email,
                                password:   GatticaConfig.password,
                                profile_id: GatticaConfig.profile_id
                              })

