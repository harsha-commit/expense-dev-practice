resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = local.azs_info[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, var.subnet_tags, {
    Name = "${var.project_name}-${var.environment}-public-${local.azs_info[count.index]}-subnet"
  })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = local.azs_info[count.index]

  tags = merge(var.common_tags, var.subnet_tags, {
    Name = "${var.project_name}-${var.environment}-private-${local.azs_info[count.index]}-subnet"
  })
}

resource "aws_subnet" "database" {
  count             = length(var.database_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidr_blocks[count.index]
  availability_zone = local.azs_info[count.index]

  tags = merge(var.common_tags, var.subnet_tags, {
    Name = "${var.project_name}-${var.environment}-database-${local.azs_info[count.index]}-subnet"
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = merge(var.common_tags, var.subnet_tags, {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  })
}
