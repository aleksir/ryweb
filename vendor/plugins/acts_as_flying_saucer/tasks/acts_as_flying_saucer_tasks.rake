 desc "Generate nailgun script"
 task :acts_as_flying_saucer do
    dest_file = File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','..', "script", 'flying_saucer_nailgun'))
		src_file = File.expand_path(File.join(File.dirname(__FILE__),'..','lib','generator' ,'flying_saucer_nailgun'))
		FileUtils.cp_r(src_file, dest_file)
		File.chmod(0755,dest_file)
 end
