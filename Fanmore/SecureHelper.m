//
//  SecureHelper.m
//  Fanmore
//
//  Created by Cai Jiang on 4/11/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "SecureHelper.h"
#import "NSData+SSToolkitAdditions.h"

@implementation SecureHelper

static SecKeyRef _public_key=nil;

+ (SecKeyRef) getPublicKey{ // 从公钥证书文件中获取到公钥的SecKeyRef指针
    
    if(_public_key == nil){
        
        NSData *certificateData = [NSData dataWithBase64String:Fanmore_RSA_PK_Base64];
        
        SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
        
        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
        
        SecTrustRef myTrust;
        
        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
        
        SecTrustResultType trustResult;
        
        if (status == noErr) {
            
            status = SecTrustEvaluate(myTrust, &trustResult);
            
        }
        
        _public_key = SecTrustCopyPublicKey(myTrust);
        
        CFRelease(myCertificate);
        
        CFRelease(myPolicy);
        
        CFRelease(myTrust);
        
    }
    
    return _public_key;
    
}

+ (NSData*) rsaEncryptData:(NSData*) data{
    NSData *stringBytes = data;
    SecKeyRef key = [self getPublicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    
    size_t blockSize = cipherBufferSize - 11;
    
    size_t blockCount = (size_t)ceil([stringBytes length] / (double)blockSize);
    
    NSMutableData *encryptedData = [[NSMutableData alloc] init] ;
    
    for (int i=0; i<blockCount; i++) {
        
        int bufferSize = MIN(blockSize,[stringBytes length] - i * blockSize);
        
        NSData *buffer = [stringBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        
        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes],
                                        
                                        [buffer length], cipherBuffer, &cipherBufferSize);
        
        if (status == noErr){
            
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) free(cipherBuffer);
            return nil;
        }
        
    }
    
    if (cipherBuffer) free(cipherBuffer);
    
    //  NSLog(@"Encrypted text (%d bytes): %@", [encryptedData length], [encryptedData description]);
    //  NSLog(@"Encrypted text base64: %@", [Base64 encode:encryptedData]);
    
    return encryptedData;
}

+ (NSData*) rsaEncryptString:(NSString*) string{
    return [SecureHelper rsaEncryptData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}




@end
