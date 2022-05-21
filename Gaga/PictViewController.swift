//
//  PictViewController.swift
//  Gaga
//
//  Created by Erendira Cruz Reyes on 20/05/22.
//

import UIKit

class PictViewController: UIViewController {
    var item: Item?
    var imageView = UIImageView()
    var a_i = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.frame = self.view.frame.insetBy(dx: 20, dy: 20)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        a_i.style = .large
        a_i.color = .red
        a_i.hidesWhenStopped = true
        a_i.center = self.view.center
        self.view.addSubview(a_i)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let lItem = self.item else {return}
        
        //Comprobar si existe la imagen local
        if (cargaImagenLocal(lItem.pict)){
            print("texto cargado desde local")
        }else{
            if let url = URL(string:DataManager.instance.baseURL + "/" + lItem.pict) {
                let request = URLRequest(url: url)
                let sesion = URLSession.shared
                let tarea = sesion.dataTask(with: request) { bytes, response, error in
                    if error != nil {
                        print ("ocurrio un error \(error!.localizedDescription)")
                    }
                    else {
                        let image = UIImage(data: bytes!)
                        self.guardaImagen(bytes!, lItem.pict)
                        DispatchQueue.main.async {
                            self.imageView.image = image
                            self.a_i.stopAnimating()
                        }
                    }
                }
                a_i.startAnimating()
                tarea.resume()
                /* ESTO ES PARA DESCARGAR DIRECTAMENTE
                 do {
                     let bytes = try Data(contentsOf: url)
                     let image = UIImage(data: bytes)
                     self.imageView.image = image
                 }
                 catch {
                     print ("ocurrio un error \(error.localizedDescription)")
                 }*/
            }
            
        }
    }
    func cargaImagenLocal(_ nombre: String)-> Bool{
        // 1. Obtener la ruta a documents
        let urlAdocs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)
        // 2. comprobar si existe el archivo
        
        if (FileManager.default.fileExists(atPath: urlAlArchivo.path))
        {
            
            do{
                let bytes = try Data(contentsOf: urlAlArchivo)
                let image = UIImage(data: bytes)
                self.imageView.image = image
                
            }
            catch{
                
            }
           return true
            
        }else {
            return false
        }
    }
    func guardaImagen(_ bytes:Data,_ nombre:String){
        let urlAdocs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)
        do{
            try bytes.write(to: urlAlArchivo)
        }catch{
            print("no se pudo salvar la imagen")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
