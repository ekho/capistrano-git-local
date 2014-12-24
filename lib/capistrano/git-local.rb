require 'capistrano/git'

namespace :git_local do

  def strategy
    @strategy ||= Capistrano::Git.new(self, fetch(:git_strategy, Capistrano::Git::DefaultStrategy))
  end

  def test_remote
    remote = ''
    within repo_path do
      remote = capture(:git, 'remote', '-v').split("\n").select{ |i| i[/\(fetch\)$/] }[0].gsub(/^origin\s+(\S+)\s+\(fetch\)$/, '\1')
    end
    remote == repo_url
  end

  desc 'Check that the repository is reachable'
  task :check do |task|
    run_locally do debug "Task #{task} start" end

    run_locally do
      exit 1 unless strategy.check
    end

    run_locally do debug "Task #{task} finish" end
  end

  desc 'Clone the repo to the cache'
  task :clone do |task|
    run_locally do debug "Task #{task} start" end

    run_locally do
      if strategy.test && test_remote
        info t(:mirror_exists, at: repo_path)
      else
        within deploy_path do
          execute :rm, '-rf', repo_path if test :test, '-d', repo_path
          strategy.clone
        end
      end
    end

    run_locally do debug "Task #{task} finish" end
  end

  desc 'Update the repo mirror to reflect the origin state'
  task :update => :clone do |task|
    run_locally do debug "Task #{task} start" end
    run_locally do
      within repo_path do
        strategy.update
      end
    end

    run_locally do debug "Task #{task} finish" end
  end

  desc 'Copy repo to releases'
  task :create_release => :update do |task|
    run_locally do debug "Task #{task} start" end

    run_locally do
      within repo_path do
        execute :mkdir, '-p', release_path
        strategy.release
      end
    end

    run_locally do debug "Task #{task} finish" end
  end

  desc 'Determine the revision that will be deployed'
  task :set_current_revision do |task|
    run_locally do debug "Task #{task} start" end

    run_locally do
      within repo_path do
        set :current_revision, strategy.fetch_revision.strip
      end
    end

    run_locally do debug "Task #{task} finish" end
  end

end