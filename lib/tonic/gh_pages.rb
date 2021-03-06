module Tonic
  module GhPages
    class << self

      def activate(template = nil)
        gh_pages(template)
      end

      def push_pages
        if in_gh_pages_branch?
          exec 'git push -f origin gh-pages'
        else
          puts 'Forget about it bro'
        end
      end

      private

      def in_gh_pages_branch?
        branches = sh('git branch')
        branches.lines.any? { |it| it =~ /\* gh-pages/ }
      end

      def gh_pages(template = nil)
        are_you_in_repo?

        if branch_exists?
          abort 'You shall no pass. First you should delete gh-pages branch'
        end

        check_status
        create_branch
        remove_all_files
        create template
        commit_changes
      end

      def create(template = nil)
        case template
        when 'middleman'
          sh 'middleman init ./'
        when 'jekyll'
          puts 'I will add integration with Jekyll later, now I will install tonic-template'
          Template.create
        else
          Template.create
        end
      end

      def are_you_in_repo?
        check = sh('git status').to_s
        if check =~ /Not a git repository/
          abort "You are not in git repo. If you want to create tonic-template write `tonic new my_app`"
        end
      end

      def branch_exists?
        branches = sh('git branch')
        branches.lines.any? { |it| it =~ /gh-pages/ }
      end

      def check_status
        unless sh('git status -s').to_s.empty?
          abort "You have uncommited changes. I don't want to you to loose it."
        end
      end

      # TODO: Later I will think about how to do it through github-gem properly
      def create_branch
        sh 'git branch gh-pages'
        sh 'git checkout gh-pages'
      end

      def remove_all_files
        sh 'rm -rf ./*'
      end

      def commit_changes
        sh "git add ."
        sh "git commit -am 'Init github pages'"
      end

      def sh(*command)
        Tonic::Shell.run(*command)
      end

    end
  end
end
