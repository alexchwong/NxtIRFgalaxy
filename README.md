# NxtIRFgalaxy
NxtIRF as a galaxy app

# Installation (local Galaxy server)

### Clone the repository:

```
cd ~/bin
git clone https://github.com/alexchwong/NxtIRFgalaxy
```

### Compile the NxtIRF executable:

```
cd NxtIRFgalaxy
make
```

### Setting up a local Galaxy and Installing NxtIRF

To set up a local version of Galaxy (latest release version 21.05):

```
cd ~/bin
git clone -b release_21.05 https://github.com/galaxyproject/galaxy.git
```

To start Galaxy:

```
cd ~/bin/galaxy
sh run.sh --daemon
```

### Installing NxtIRF to Galaxy

```
cd ~/bin/NxtIRFgalaxy
cp nxtirf ~/bin/galaxy/tools/
```

### Setting up Galaxy for NxtIRF:

In Galaxy main configuration file: `galaxy.yml` 

```
cp config/galaxy.yml.sample config/galaxy.yml
```

#### Recommended changes:

To enable remote connections to port 8080:
* http: 0.0.0.0:8080

To save job and tool data to a different location (as they are typically gigabytes of data):
* file_path: /path/to/drive_with_lots_of_space/galaxy/objects
* tool_data_path: /path/to/drive_with_lots_of_space/galaxy/tool-data

To recognise custom tool and job configurations:
* job_config_file: config/job_conf.xml
* tool_config_file: config/tool_conf.xml

To assign admins (change email to admin's email login):
* admin_users: user@email.com

To set up a path where users can dump files to a folder to be used in Galaxy:
* ftp_upload_dir: /path/to/shared_folder
* ftp_upload_site: sftp://user_name@192.168.190.190 (set this to the FTP site that users use to upload files from local to server)
* ftp_upload_dir_identifier: username

Users can create subfolders named by their username. Files placed in this folder can be accessed via "FTP"

#### Configuring `tool_conf.xml` to install NxtIRF:

```
cp config/tool_conf.xml.sample config/tool_conf.xml
```

Add the following within the `<toolbox> </toolbox>` brackets of `tool_conf.xml`:

```
  <section name="NxtIRF / IRFinder" id="nxtirf">
    <tool file="nxtirf/nxtirf_galaxy.xml"/>
  </section>
```

#### To configure the number of threads per job:

```
cp config/job_conf.xml.sample config/job_conf.xml
```

In `job_conf.xml` change the `workers` to the desired number of threads per job (e.g. to 8 threads):

In `plugins`:

```
  <plugins>
    <plugin id="local" type="runner" load="galaxy.jobs.runners.local:LocalJobRunner" workers="8"/>
  </plugins>
```

In `destinations`:

```
  <destinations>
	<destination id="local" runner="local">
	  <param id="local_slots">8</param>
	</destination>
  </destinations>
```

### Restart the Galaxy server:

This must be done after any tweaks to the Galaxy settings in order for changes to take effect:

```
# Stop the Galaxy server
sh run.sh --stop-daemon

# Start the Galaxy server
sh run.sh --stop-daemon
```

# Other useful tools for your local Galaxy server:

### Data Managers:
* data_manager_fetch_genome_dbkeys_all_fasta: Designates a FASTA file as a genome FASTA
* data_manager_star_index_builder: Builds a STAR genome from a genome FASTA

### Software
* rgrnastar: Aligns a single or paired FASTQ file(s) using STAR (Optional use a GTF file)
* sra_tools: Extracts FASTQ files from SRA files
* featurecounts: Perform gene counts