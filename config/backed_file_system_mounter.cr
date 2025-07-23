BakedFileSystemMounter.assemble(["dist", "markdowns"])

if LuckyEnv.production?
  STDERR.puts "Mounting from baked file system ..."
  BakedFileSystemMounter::Storage.mount
end
