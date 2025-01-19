BakedFileSystemMounter.assemble(["public", "src/pages/docs"])

if LuckyEnv.production?
  STDERR.puts "Mounting from baked file system ..."
  BakedFileSystemStorage.mount
end
