class PluginMutagen
  
  def self.vmUp(node)
    node.trigger.after :up do |trigger|
      
      # TODO May need to clear mutagen.yml.lock if it exists from a failure
      
      trigger.name = "Mutagen"
      trigger.warn = "Mutagen Project Start"
      trigger.run = {inline: "mutagen project start"}
    end
  end
  
  def self.vmHalt(node)
    node.trigger.before :halt do |trigger|
      trigger.name = "Mutagen"
      trigger.warn = "Mutagen Project Terminate"
      trigger.run = {inline: "mutagen project terminate"}
      
      # TODO May also want to check for and remove any mutagen.yml.lock if it exists
    end
  end
  
  def self.vmDestroy(node)
    node.trigger.before :destroy do |trigger|
      trigger.name = "Mutagen"
      trigger.warn = "Mutagen Project Start"
      trigger.run = {inline: "mutagen project terminate"}
      
      # TODO May also want to check for and remove any mutagen.yml.lock if it exists
    end
  end
  
end