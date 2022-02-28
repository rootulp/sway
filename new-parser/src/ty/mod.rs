use crate::priv_prelude::*;

/*
mod array;
mod tuple;

pub use array::*;
pub use tuple::*;
*/

#[derive(Debug, Clone)]
pub enum Ty {
    /*
    Path {
        path: PathType,
    },
    Tuple(TyTuple),
    Array(TyArray),
    Str {
        str_token: StrToken,
        length: SquareBrackets<Box<Expr>>,
    },
    */
}

impl Spanned for Ty {
    fn span(&self) -> Span {
        //match self {
        match *self {
            /*
            Ty::Path { path } => path.span(),
            Ty::Tuple(ty_tuple) => ty_tuple.span(),
            Ty::Array(ty_array) => ty_array.span(),
            Ty::Str { str_token, length } => {
                Span::join(str_token.span(), length.span())
            },
            */
        }
    }
}

#[derive(Clone)]
pub struct ExpectedTypeError {
    pub position: usize,
}

pub fn ty<R>() -> impl Parser<Output = Ty, Error = ExpectedTypeError, FatalError = R> + Clone {
    /*
    let ty_str = {
        str_token()
        .then_optional_whitespace()
        .then(square_brackets(padded(lazy(|| expr()).map(Box::new))))
        .map(|(str_token, length)| {
            Ty::Str { str_token, length }
        })
    };
    let path = {
        path_type()
        .map(|path| Ty::Path { path })
    };
    let tuple = {
        ty_tuple()
        .map(|ty_tuple| Ty::Tuple(ty_tuple))
    };
    let array = {
        ty_array()
        .map(|ty_array| Ty::Array(ty_array))
    };
    */

    or! {
        /*
        ty_str,
        path,
        tuple,
        array,
        */
    }
    .or_else(|(), span| Err(Ok(ExpectedTypeError { position: span.start() })))
}