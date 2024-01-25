##### SUB - WORKFLOW DEFINITION #####
workflow sub_wf{
	File Fasta
	String Fasta_name
	File Allele_List
	Array[String] Allele_array = read_lines(Allele_List)

	scatter(Allele in Allele_array){

	call predict{
		input:
			Fasta = Fasta,
			Fasta_name = Fasta_name,
			Allele = Allele
	}

	}

}

##### TASKS #####

task predict{
	File Fasta
	String Allele
	String Fasta_name

	command{
	/usr/local/src/netmhc2/netMHCIIpan-3.2/netMHCIIpan -f ${Fasta} -a ${Allele} > "${Fasta_name}.${Allele}.netmhc2pan.txt"
	}
	output{
	File prediction_file = "${Fasta_name}.${Allele}.netmhc2pan.txt"
	}
	runtime{
	docker: "plichta/hbota_stepb:02022022"
	bootDiskSizeGb: 25
	cpu: "1"
	disks: "local-disk 75 LOCAL"
	memory: "16 GB"
	preemptible: 2
	}
}

