# NxtIRFgalaxy
NxtIRF as a galaxy app

# Installation (local Galaxy server)

### Clone the repository:

```
git clone https://github.com/alexchwong/NxtIRFgalaxy
```

### Compile the NxtIRF executable:

```
cd NxtIRFgalaxy
make
```

### Install the tool in Galaxy

This assumes the Galaxy installation is in the `~/bin/galaxy` path:

```
GALAXY_DIR=~/bin/galaxy

mkdir ${GALAXY_DIR}/NxtIRF
cp tool/* ${GALAXY_DIR}/tools/NxtIRF
```

Make sure the following is added to `tool_conf.xml` file in the Galaxy root directory:

```
  <section name="NxtIRF / IRFinder" id="nxtirf">
    <tool file="NxtIRF/nxtirf_galaxy.xml"/>
  </section>
```

Restart the Galaxy server:

```
# Stop the Galaxy server
sh ${GALAXY_DIR}/run.sh --stop-daemon

# Start the Galaxy server
sh ${GALAXY_DIR}/run.sh --stop-daemon
```

### Important Galaxy Config Tweaks:

```
cp ${GALAXY_DIR}/config/galaxy.yml.sample ${GALAXY_DIR}/config/galaxy.yml
cp ${GALAXY_DIR}/config/tool_conf.xml.sample ${GALAXY_DIR}/config/tool_conf.xml
```

* http: 0.0.0.0:8080
* threads: 8
* file_path: /path/to/drive_with_lots_of_space
* admin_users: logins_of_admin_users
* tool_config_file: config/tool_conf.xml

# Other useful tools for your local Galaxy server:

### Data Managers:
* data_manager_fetch_genome_dbkeys_all_fasta: Designates a FASTA file as a genome FASTA
* data_manager_star_index_builder: Builds a STAR genome from a genome FASTA

### Software
* rgrnastar: Aligns a single or paired FASTQ file(s) using STAR (Optional use a GTF file)
* sra_tools: Extracts FASTQ files from SRA files

