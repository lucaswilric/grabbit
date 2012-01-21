GrabbitUrl = "http://localhost:3000"
DestinationRoot = "/media/20D0FF1ED0FEF93C/Downloads"
GrabbitTag = "leverage"

FtpRoot = "ftp://grabbit/Downloads"
FtpFSRootRegex = /\/media\/20D0FF1ED0FEF93C\/Downloads\//
FtpReadyTag = "media"
FtpDestinationRoot = "/home/lucas/Downloads/"

TransmissionConfig = {"url" => "http://transmission:9091/transmission/rpc", "username" => "transmission", "password" => "n8Xic6RS"}

Status = {
    :not_started => "Not Started",
    :in_progress => "In Progress",
    :finished => "Finished",
    :failed => "Failed",
    :retry => "Retry",
    :cancelled => "Cancelled"
}

