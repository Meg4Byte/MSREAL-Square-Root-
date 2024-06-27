#include <linux/kernel.h>
#include <linux/string.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/types.h>
#include <linux/cdev.h>
#include <linux/kdev_t.h>
#include <linux/uaccess.h>
#include <linux/errno.h>
#include <linux/device.h>
#include <linux/wait.h>
#include <linux/mutex.h>
#include <linux/slab.h>

MODULE_LICENSE("GPL");

#define DEV_ADDR // ?
#define X_ADDR_OFFSET 0
#define START_ADDR_OFFSET 4
#define Y_ADDR_OFFSET 8
#define READY_ADDR_OFFSET 12

#define BUFF_SIZE 100 

int numbers [BUFF_SIZE]; 
int i = 0;
int read = 0;

dev_t my_dev_id;
static struct class *my_class;
static struct device *my_device;
static struct cdev *my_cdev;
  
int sqrt_open(struct inode *pinode, struct file *pfile);
int sqrt_close(struct inode *pinode, struct file *pfile);
ssize_t sqrt_read(struct file *pfile, char __user *buffer, size_t length, loff_t *offset);
ssize_t sqrt_write(struct file *pfile, const char __user *buffer, size_t length, loff_t *offset);

struct file_operations my_fops =
{
	.owner = THIS_MODULE,
	.open = sqrt_open,
	.read = sqrt_read,
	.write = sqrt_write,
	.release = sqrt_close,
};

int sqrt_open(struct inode *pinode, struct file *pfile) 
{
    printk(KERN_INFO "Succesfully opened sqrt\n");
    return 0;
}

int sqrt_close(struct inode *pinode, struct file *pfile) 
{
    printk(KERN_INFO "Succesfully closed sqrt\n");
    return 0;
}

ssize_t sqrt_read(struct file *pfile, char __user *buffer, size_t length, loff_t *offset) 
{
    int ret;
    int res;
    int ready_val;
    char buff[BUFF_SIZE];
    long int len;
    if (endRead){
        endRead = 0;
        pos = 0;
        printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }

    while(ioread32(/* resources->ready_addr */) == 0) // cat pooling, ready_addr = DEV_ADDR+READY_ADDR_OFFSET
    ;
    
    res = ioread32(/* resources->y_addr */); // *(DEV_ADDR+Y_ADDR_OFFSET)
    
    len = scnprintf (buff,"%d:%d, ", numbers[read++], res);
    ret = copy_to_user(buffer, buff, len);
    if(ret)
        return -EFAULT;
    if (read == i) {
        endRead = 1;}
    return len;
}

ssize_t sqrt_write(struct file *pfile, const char __user *buffer, size_t length, loff_t *offset) 
{
    char buff[BUFF_SIZE];
    int position, value, ret;
    int dataIndex = 0;  // Index for traversing the input data
    int buffIndex = 0;  // Index for storing characters in buff
    ret = copy_from_user(buff, buffer, length);

    if (ret)
        return -EFAULT;

    buff[length - 1] = '\0';

    while (buff[buffIndex] != '\0') {
        if(buff[buffIndex] == ',') {
            buff[buffIndex] = '\0';
            ret = kstrtol(dataIndex, 10, &numbers[i++]);
            dataIndex = buffIndex+1;
        }

        if (!ret)
            iowrite32((u32)numbers[i-1], lp->base); // writing the last read number to the sqrt module, 
                                                    // lp->base = DEV_ADDR + Y_ADDR_OFFSET
        else
            printk(KERN_WARNING "Wrong command format\nexpected:n,m\n\t n-position\n\t m-value\n");

        buffIndex++; // Move to the next character in buff
        }
    return length;
}

static int __init sqrt_init(void)
{    int ret;
   ret = alloc_chrdev_region(&my_dev_id, 0, 1, "sqrt");
   if (ret){
      printk(KERN_ERR "failed to register char device\n");
      return ret;
   }
   printk(KERN_INFO "char device region allocated\n");

   my_class = class_create(THIS_MODULE, "sqrt_class");
   if (my_class == NULL){
      printk(KERN_ERR "failed to create class\n");
      goto fail_0;
   }
   printk(KERN_INFO "class created\n");
   
   my_device = device_create(my_class, NULL, my_dev_id, NULL, "sqrt");
   if (my_device == NULL){
      printk(KERN_ERR "failed to create device\n");
      goto fail_1;
   }
   printk(KERN_INFO "device created\n");

	my_cdev = cdev_alloc();	
	my_cdev->ops = &my_fops;
	my_cdev->owner = THIS_MODULE;
	ret = cdev_add(my_cdev, my_dev_id, 1);
	if (ret)
	{
      printk(KERN_ERR "failed to add cdev\n");
		goto fail_2;
	}
   printk(KERN_INFO "cdev added\n");
   printk(KERN_INFO "Hello world\n");

   return 0;

   fail_2:
      device_destroy(my_class, my_dev_id);
   fail_1:
      class_destroy(my_class);
   fail_0:
      unregister_chrdev_region(my_dev_id, 1);
   return -1;
}

static void __exit sqrt_exit(void)
{
   cdev_del(my_cdev);
   device_destroy(my_class, my_dev_id);
   class_destroy(my_class);
   unregister_chrdev_region(my_dev_id,1);
   printk(KERN_INFO "Goodbye, cruel world\n");
}

module_init(sqrt_init);
module_exit(sqrt_exit);