BakedFileSystemMounter.assemble(["public", "markdowns"])

if LuckyEnv.production?
  STDERR.puts "Mounting from baked file system ..."
  BakedFileSystemStorage.mount
end
